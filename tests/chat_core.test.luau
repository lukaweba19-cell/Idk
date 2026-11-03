-- Lune tests for the chat + translation core inside re.lua
--
--   lune run tests/chat_core.test.luau
--
-- The core is sliced out of re.lua between the CHAT_CORE markers and loaded
-- with stubbed Roblox globals (game / Players / player / TextChatService),
-- a stubbed executor `request` that records every HTTP call, and a stubbed
-- RBXGeneral channel that records every sent message.
local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")

local BEGIN = "--[[ CHAT_CORE_BEGIN ]]"
local END_MARK = "--[[ CHAT_CORE_END ]]"

local source = fs.readFile("re.lua")

local pass, fail = 0, 0
local function check(name, cond, extra)
	if cond then
		pass = pass + 1
		print("PASS  " .. name)
	else
		fail = fail + 1
		print("FAIL  " .. name .. (extra ~= nil and ("  -> " .. tostring(extra)) or ""))
	end
end

-- whole script must still be valid Luau
local okSyntax, syntaxErr = pcall(function()
	local bytecode = luau.compile(source)
	assert(bytecode ~= nil)
end)
check("re.lua compiles", okSyntax, syntaxErr)

local sPos = string.find(source, BEGIN, 1, true)
local ePos = string.find(source, END_MARK, 1, true)
assert(sPos and ePos and ePos > sPos, "CHAT_CORE markers not found in re.lua")
local core = string.sub(source, sPos, ePos + #END_MARK)
	.. "\nreturn { CHAT = CHAT, LANG = LANG, API = API, GOOGLE = GOOGLE }\n"

local function newHarness(opts)
	opts = opts or {}
	local h = { calls = {}, sent = {}, clock = 1000, modern = {}, legacy = {} }

	local function bump(sec) h.clock = h.clock + sec end
	h.bump = bump

	local HttpService = {
		JSONEncode = function(_, value)
			if type(value) == "table" and value.messages then
				return tostring(value.messages[1].content) .. "\n----\n" .. tostring(value.messages[2].content)
			end
			return tostring(value)
		end,
		JSONDecode = function(_, raw)
			raw = tostring(raw)
			if string.sub(raw, 1, 2) == "[[" then
				-- google gtx shape: [[[translated,...]],null,"detected"]
				local translated = string.match(raw, '^%[%[%["(.-)"') or ""
				local detected = string.match(raw, '%[%]%]%s*,%s*null%s*,%s*"([%a%-]+)"') or "pt"
				return { { { translated } }, nil, detected }
			end
			return { choices = { { message = { content = raw } } } }
		end,
	}
	h.HttpService = HttpService

	local function fakeRequest(req)
		h.calls[#h.calls + 1] = req
		if opts.respond then return opts.respond(req) end
		local reqUrl = tostring(req.Url or "")
		if string.find(reqUrl, "translate.googleapis.com", 1, true) then
			h.googleCalls = (h.googleCalls or 0) + 1
			if opts.googleStatus then
				return { StatusCode = opts.googleStatus, Body = "limited" }
			end
			local target = string.match(reqUrl, "tl=([%w%%%-]+)") or "en"
			local replies = {
				en = "Ok, I will give fish.",
				pt = "Ok, eu vou dar o peixe.",
				es = "Hola amigo",
			}
			local text = replies[target] or "Hola amigo"
			return { StatusCode = 200, Body = '[[["' .. text .. '",null,null,null,1]],null,"pt"]' }
		end
		local body = tostring(req.Body)
		if string.find(body, "Message being answered", 1, true) then
			return { StatusCode = 200, Body = "LANG: pt\nTRANSLATION: Ok, eu vou dar o peixe." }
		elseif string.find(body, "language identifier", 1, true) then
			return { StatusCode = 200, Body = "LANG: pt\nTRANSLATION: Ok, I will give fish." }
		end
		return { StatusCode = 200, Body = "Hola amigo" }
	end

	local channel = {
		SendAsync = function(_, text) h.sent[#h.sent + 1] = text end,
	}
	local TextChatService = {
		ChatVersion = opts.legacy and "LegacyChatService" or "TextChatService",
		MessageReceived = {
			Connect = function(_, fn)
				h.modern[#h.modern + 1] = fn
				return { Disconnect = function() end }
			end,
		},
		TextChannels = {
			FindFirstChild = function(_, name)
				if name == "RBXGeneral" then return channel end
				return nil
			end,
		},
	}

	local legacyEvent = {
		OnClientEvent = {
			Connect = function(_, fn)
				h.legacy[#h.legacy + 1] = fn
				return { Disconnect = function() end }
			end,
		},
	}
	local chatEvents = {
		FindFirstChild = function(_, name)
			if name == "OnMessageDoneFiltering" then return legacyEvent end
			return nil
		end,
	}
	local replicated = {
		FindFirstChild = function(_, name)
			if name == "DefaultChatSystemChatEvents" then return chatEvents end
			return nil
		end,
	}

	local gameStub = {
		GetService = function(_, name)
			if name == "TextChatService" then return TextChatService end
			if name == "HttpService" then return HttpService end
			if name == "ReplicatedStorage" then return replicated end
			error("no stub for service " .. name)
		end,
	}

	local localPlayer = { UserId = 1, DisplayName = "Me", Name = "Me" }
	local players = {
		GetPlayerByUserId = function(_, id)
			if id == 1 then return localPlayer end
			return { UserId = id, DisplayName = "God", Name = "God" }
		end,
		GetFriendsAsync = function(_, _userId)
			local page = {}
			for i, id in ipairs(opts.friends or {}) do
				page[i] = { Id = id, Username = "Friend" .. tostring(id) }
			end
			return {
				GetCurrentPage = function() return page end,
				AdvanceToNextPageAsync = function() end,
				IsFinished = true,
			}
		end,
	}

	local osStub = { clock = function() return h.clock end, time = os.time }
	local taskStub = {
		spawn = function(fn, ...)
			local ok, err = pcall(fn, ...)
			if not ok then error("task.spawn: " .. tostring(err), 0) end
		end,
		wait = function() end,
		delay = function(_, fn)
			local ok, err = pcall(fn)
			if not ok then error("task.delay: " .. tostring(err), 0) end
		end,
	}

	local env = {
		game = gameStub,
		Players = players,
		player = localPlayer,
		Enum = { ChatVersion = { TextChatService = "TextChatService" } },
		HttpService = HttpService,
		request = fakeRequest,
		utf8 = utf8,
		string = string,
		table = table,
		math = math,
		os = osStub,
		task = taskStub,
		pcall = pcall,
		error = error,
		type = type,
		tostring = tostring,
		tonumber = tonumber,
		select = select,
		pairs = pairs,
		ipairs = ipairs,
		next = next,
		print = print,
		getgenv = function() return opts.genv or {} end,
		OPENROUTER_KEY = "test-key",
		OPENROUTER_MODEL = "openrouter/free",
	}

	-- executor workspace files (keys.json); opts.noFiles simulates an executor
	-- that has no readfile / writefile at all
	if not opts.noFiles then
		local files = {}
		for name, body in pairs(opts.files or {}) do files[name] = body end
		h.files = files
		env.isfile = function(name) return files[name] ~= nil end
		env.readfile = function(name) return files[name] end
		env.writefile = function(name, data) files[name] = data end
	end

	local chunk = luau.load(core, { environment = env, debug_name = "re.lua chat core" })
	local loaded = chunk()
	h.CHAT, h.LANG, h.API, h.GOOGLE = loaded.CHAT, loaded.LANG, loaded.API, loaded.GOOGLE
	-- Google is the primary path now, so tests opt in and the rest keep
	-- exercising the OpenRouter fallback
	if not opts.google then h.GOOGLE.rest(1000000000, "rested for this test") end
	h.CHAT.startListening() -- what the script does once its panel is built
	return h
end

local function receive(h, userId, text, channelName)
	for _, fn in ipairs(h.modern) do
		fn({
			Text = text,
			TextSource = { UserId = userId },
			TextChannel = channelName and { Name = channelName } or nil,
		})
	end
end

local function last(arr) return arr[#arr] end

local function googleCalls(h)
	local n = 0
	for _, call in ipairs(h.calls) do
		if string.find(tostring(call.Url), "translate.googleapis.com", 1, true) then
			n = n + 1
		end
	end
	return n
end

----------------------------------------------------------------------
-- 1. receiving chat: 0 requests, no auto translation
----------------------------------------------------------------------
do
	local h = newHarness()
	local C = h.CHAT
	check("startup makes no OpenRouter request", #h.calls == 0, #h.calls)

	receive(h, 99, "Ok, eu vou dar peixe.")
	check("incoming message shows up once", #C.messages == 1, #C.messages)
	check("incoming message costs 0 requests", #h.calls == 0, #h.calls)
	check("incoming message is not auto-translated", C.messages[1].state == "original")
	check("apiRequests counter matches", C.apiRequests == #h.calls, C.apiRequests)

	receive(h, 99, "another line")
	check("second incoming message also 0 requests", #h.calls == 0, #h.calls)

	------------------------------------------------------------------
	-- 2. manual translate: exactly 1 request, second click free
	------------------------------------------------------------------
	local msg = C.messages[1]
	local before = #h.calls
	C.manualTranslate(msg)
	check("manual translate = 1 request", #h.calls - before == 1, #h.calls - before)
	check("manual translate translated the line", msg.state == "translated" and msg.translated == "Ok, I will give fish.", msg.translated)
	check("manual translate detected the language", msg.lang == "pt", msg.lang)

	before = #h.calls
	C.manualTranslate(msg)
	check("second globe click = 0 requests", #h.calls - before == 0, #h.calls - before)
	check("second globe click flips back to original", msg.state == "original", msg.state)

	before = #h.calls
	C.manualTranslate(msg)
	check("third globe click still 0 requests (cached)", #h.calls - before == 0, #h.calls - before)
	check("third globe click shows the translation again", msg.state == "translated", msg.state)
	check("apiRequests counter still matches", C.apiRequests == #h.calls, C.apiRequests)
end

----------------------------------------------------------------------
-- 3. reply: exactly 1 request, translated into their language
----------------------------------------------------------------------
do
	local h = newHarness()
	local C = h.CHAT

	receive(h, 77, "Eae mano, bora")
	local target = C.messages[1]
	local before = #h.calls

	C.replyTo(target)
	check("reply click costs 0 requests", #h.calls - before == 0, #h.calls - before)
	check("reply target is remembered", C.replyTarget == target)

	C.enqueueSend("ok i will give you the fish")
	check("reply send = 1 request", #h.calls - before == 1, #h.calls - before)
	check("reply was translated into their language", last(h.sent) == "Ok, eu vou dar o peixe.", last(h.sent))
	check("reply target cleared after sending", C.replyTarget == nil)
	check("sent line is in the panel", #C.messages == 2, #C.messages)
	check("sent line is marked as mine", C.messages[2].mine == true)
	check("reply learned the language", h.LANG.playerLang[77] == "pt", h.LANG.playerLang[77])
	check("reply total stays at 1 request", #h.calls == 1, #h.calls)

	-- a second send must not reuse the finished reply
	local before2 = #h.calls
	C.enqueueSend("plain line")
	check("send after reply does not translate (0 requests)", #h.calls - before2 == 0, #h.calls - before2)
	check("send after reply goes out as typed", last(h.sent) == "plain line", last(h.sent))
end

----------------------------------------------------------------------
-- 4. language selector
----------------------------------------------------------------------
do
	local h = newHarness()
	local C = h.CHAT

	C.setSpeakLang("es")
	local before = #h.calls
	C.enqueueSend("hello friend")
	check("speaking in Spanish = 1 request", #h.calls - before == 1, #h.calls - before)
	check("Spanish request really targets Spanish", string.find(tostring(last(h.calls).Body), "Spanish", 1, true) ~= nil)
	check("Spanish reply text used", last(h.sent) == "Hola amigo", last(h.sent))

	before = #h.calls
	C.enqueueSend("hello friend")
	check("repeating the same line = 0 requests (cached)", #h.calls - before == 0, #h.calls - before)

	C.setSpeakLang("en")
	before = #h.calls
	C.enqueueSend("hello again")
	check("speaking in English = 0 requests", #h.calls - before == 0, #h.calls - before)
	check("English goes out exactly as typed", last(h.sent) == "hello again", last(h.sent))

	C.setSpeakLang("auto")
	before = #h.calls
	C.enqueueSend("auto line")
	check("auto + no reply = 0 requests", #h.calls - before == 0, #h.calls - before)
end

----------------------------------------------------------------------
-- 5. no double sending, no duplicate rows
----------------------------------------------------------------------
do
	local h = newHarness()
	local C = h.CHAT

	local beforeSent = #h.sent
	local ok = C.enqueueSend("first line")
	check("send reports success", ok == true)
	check("send went out exactly once", #h.sent == beforeSent + 1, #h.sent - beforeSent)
	check("send added exactly one row", #C.messages == 1, #C.messages)

	-- the in-flight guard: a second Enter while sending must be refused
	C.sending = true
	local okBusy = C.enqueueSend("first line")
	C.sending = false
	check("second press while sending is refused", okBusy == false)
	check("refused press sent nothing", #h.sent == beforeSent + 1, #h.sent - beforeSent)
	check("refused press added no row", #C.messages == 1, #C.messages)

	-- our own line coming back from the server must not be added again
	C.dispatch("echoed line", "en")
	check("dispatch added our row", #C.messages == 2, #C.messages)
	receive(h, 1, "echoed line")
	check("own echo did not duplicate the row", #C.messages == 2, #C.messages)

	-- a filtered echo of our own line must not duplicate it either
	C.dispatch("line that gets filtered", "en")
	receive(h, 1, "############")
	check("filtered echo did not duplicate the row", #C.messages == 3, #C.messages)

	-- the same line delivered by two listeners at once
	h.bump(0)
	local beforeRows = #C.messages
	receive(h, 55, "gg")
	receive(h, 55, "gg")
	check("duplicate delivery adds one row", #C.messages == beforeRows + 1, #C.messages - beforeRows)

	-- the same text later is a real new message
	h.bump(10)
	receive(h, 55, "gg")
	check("same text later is a new message", #C.messages == beforeRows + 2, #C.messages - beforeRows)
	check("receiving all of that cost 0 requests", #h.calls == 0, #h.calls)
end

----------------------------------------------------------------------
-- 6. only one chat system is listened to (that is what doubled lines)
----------------------------------------------------------------------
do
	local h = newHarness()
	check("modern chat: one MessageReceived listener", #h.modern == 1, #h.modern)
	check("modern chat: legacy listener is NOT attached", #h.legacy == 0, #h.legacy)

	local legacy = newHarness({ legacy = true })
	check("legacy chat: legacy listener attached", #legacy.legacy == 1, #legacy.legacy)
	local rows = #legacy.CHAT.messages
	for _, fn in ipairs(legacy.modern) do
		fn({ Text = "same line", TextSource = { UserId = 42 } })
	end
	for _, fn in ipairs(legacy.legacy) do
		fn({ Message = "same line", FromSpeaker = "God", SpeakerUserId = 42 })
	end
	check("both listeners deliver one row only", #legacy.CHAT.messages == rows + 1, #legacy.CHAT.messages - rows)
	check("both listeners cost 0 requests", #legacy.calls == 0, #legacy.calls)
end


----------------------------------------------------------------------
-- 7. language names + comprehensive local detection
----------------------------------------------------------------------
do
	local h = newHarness()
	local L = h.LANG

	check("name for fr", L.displayName("fr") == "French", L.displayName("fr"))
	check("name for pt-BR", L.displayName("pt-BR") == "Portuguese", L.displayName("pt-BR"))
	check("name for a full name", L.displayName("Portuguese") == "Portuguese", L.displayName("Portuguese"))
	check("name for ISO 639-2", L.displayName("por") == "Portuguese", L.displayName("por"))
	check("name for zh-Hans", L.displayName("zh-Hans") == "Chinese", L.displayName("zh-Hans"))

	local unnamed, missing = {}, {}
	for code in pairs(L.names) do
		if L.displayName(code) == code then unnamed[#unnamed + 1] = code end
	end
	for _, list in ipairs({ L.words, L.marks }) do
		for code in pairs(list) do
			if not L.names[code] then missing[#missing + 1] = code end
		end
	end
	for _, entry in ipairs(L.scripts) do
		if not L.names[entry.code] then missing[#missing + 1] = entry.code end
	end
	check("every language shows a real name", #unnamed == 0, table.concat(unnamed, ","))
	check("every detected code has a name", #missing == 0, table.concat(missing, ","))

	local count = 0
	for _ in pairs(L.names) do count = count + 1 end
	check("selector offers 70+ languages", count >= 70, count)

	local cases = {
		{ "en", "ok bro i will be there in a minute" },
		{ "en", "no i dont think so" },
		{ "en", "Ok, eu vou dar peixe." },
		{ "es", "No sé qué hacer mañana" },
		{ "pt", "Eu não sei o que fazer" },
		{ "fr", "Je ne sais pas quoi faire" },
		{ "de", "Ich weiß nicht was du meinst" },
		{ "it", "Non so cosa fare adesso" },
		{ "nl", "Ik weet niet wat je bedoelt" },
		{ "pl", "Dzień dobry, jak się masz?" },
		{ "cs", "Nevím, co mám dělat" },
		{ "tr", "Merhaba, nasılsın?" },
		{ "ro", "Bună ziua, ce faci?" },
		{ "hu", "Szia, hogy vagy?" },
		{ "sv", "Jag vet inte vad du menar" },
		{ "da", "Jeg ved ikke hvad du mener" },
		{ "fi", "Minä en tiedä mitä sinä tarkoitat" },
		{ "vi", "Xin chào bạn, bạn khỏe không?" },
		{ "id", "Aku tidak tahu apa yang kamu mau" },
		{ "tl", "Kumusta ka, salamat" },
		{ "ru", "Привет, как дела?" },
		{ "uk", "Привіт, як справи?" },
		{ "bg", "Здравей, как си?" },
		{ "sr", "Здраво, како си?" },
		{ "el", "Γεια σου τι κάνεις" },
		{ "ar", "مرحبا كيف حالك" },
		{ "fa", "سلام حال شما چطور است" },
		{ "ur", "ٹھیک ہے تم کیسے ہو" },
		{ "he", "שלום מה שלומך" },
		{ "hi", "नमस्ते आप कैसे हैं" },
		{ "bn", "আপনি কেমন আছেন" },
		{ "ta", "வணக்கம் நீங்கள் எப்படி இருக்கிறீர்கள்" },
		{ "th", "สวัสดีครับ สบายดีไหม" },
		{ "ja", "こんにちは元気ですか" },
		{ "ko", "안녕하세요 반갑습니다" },
		{ "zh", "你好吗我很高兴见到你" },
		{ "ka", "გამარჯობა როგორ ხარ" },
		{ "hy", "Բարեւ ինչպես ես" },
	}
	local wrong = {}
	for _, case in ipairs(cases) do
		local got = L.detectLocal(case[2])
		if got ~= case[1] then
			wrong[#wrong + 1] = string.format("%q -> %s (want %s)", case[2], got, case[1])
		end
	end
	check("local detection on " .. #cases .. " samples", #wrong == 0, table.concat(wrong, " | "))
end

----------------------------------------------------------------------
-- 8. replying to a locally detected language is still one request
----------------------------------------------------------------------
do
	local h = newHarness()
	local C = h.CHAT
	receive(h, 88, "Eu não sei o que fazer")
	local target = C.messages[1]
	check("locally detected line gets a language tag", target.langHint == "pt", target.langHint)

	C.replyTo(target)
	local before = #h.calls
	C.enqueueSend("hello there")
	check("reply to a detected language = 1 request", #h.calls - before == 1, #h.calls - before)
	check("that request translates into Portuguese",
		string.find(tostring(last(h.calls).Body), "Portuguese", 1, true) ~= nil)
end

----------------------------------------------------------------------
-- 9. only the general channel is shown: no tabs, 0 requests
----------------------------------------------------------------------
do
	local h = newHarness({})
	local C = h.CHAT

	receive(h, 77, "eae mano", "RBXGeneral")
	receive(h, 88, "hi there", "RBXGeneral")
	receive(h, 88, "team only line", "RBXTeam")
	receive(h, 88, "selling a sword", "Trade")
	receive(h, 88, "psst", "RBXWhisper:1_88")
	check("channel is recorded", C.messages[3].channel == "RBXTeam", C.messages[3].channel)
	check("second channel is recorded", C.messages[4].channel == "Trade", C.messages[4].channel)
	check("general default channel", C.messages[2].channel == "RBXGeneral", C.messages[2].channel)
	check("general line shown", C.isVisible(C.messages[1]) == true)
	check("stranger in general shown", C.isVisible(C.messages[2]) == true)
	check("team row hidden", C.isVisible(C.messages[3]) == false)
	check("trade row hidden", C.isVisible(C.messages[4]) == false)
	check("whisper row hidden", C.isVisible(C.messages[5]) == false)

	C.enqueueSend("my own line")
	check("my own line shown", C.isVisible(last(C.messages)) == true)
	check("no tab can hide it", C.tab == nil)
	check("filtering costs no requests", #h.calls == 0, #h.calls)
end

----------------------------------------------------------------------
-- 10. up to 5 keys, automatic failover on 429
----------------------------------------------------------------------
do
	local h = newHarness({
		genv = { OPENROUTER_KEYS = { "key-a", "key-b" } },
		respond = function(req)
			local auth = tostring(req.Headers["Authorization"])
			if auth == "Bearer key-a" then
				return { StatusCode = 429, Body = '{"error":"rate limit"}', Headers = { ["retry-after"] = "30" } }
			end
			return { StatusCode = 200, Body = "Hola amigo" }
		end,
	})
	local keys = h.API.keys()
	check("both keys are known", keys[1] == "key-a" and keys[2] == "key-b", keys[1] .. "," .. keys[2])

	h.CHAT.setSpeakLang("es")
	h.CHAT.enqueueSend("hello friend")
	check("rate limited key switches to the next one", last(h.sent) == "Hola amigo", last(h.sent))
	check("the answer came from the second key", tostring(last(h.calls).Headers["Authorization"]) == "Bearer key-b")
	check("the limited key was rested", h.API.cooling["key-a"] ~= nil)
	check("two tries, not a storm", #h.calls == 2, #h.calls)

	local before = #h.calls
	h.CHAT.enqueueSend("another hello")
	check("rested key is skipped next time", #h.calls - before == 1, #h.calls - before)
	check("working key is used first again", tostring(last(h.calls).Headers["Authorization"]) == "Bearer key-b")

	local many = newHarness({
		genv = { OPENROUTER_KEYS = { "k1", "k2", "k3", "k4", "k5", "k6", "k7", "k8", "k9", "k10", "k11", "k12" } },
	})
	check("every key is kept, up to the cap of 10", #many.API.keys() == 10, #many.API.keys())
end

----------------------------------------------------------------------
-- 11. Google Translate first, OpenRouter only as the fallback
----------------------------------------------------------------------
do
	local h = newHarness({ google = true })
	local C = h.CHAT
	C.setSpeakLang("es")
	C.enqueueSend("hello friend")
	check("google answers first", googleCalls(h) == 1, googleCalls(h))
	check("google got the target language", string.find(tostring(h.calls[1].Url), "tl=es", 1, true) ~= nil)
	check("google translation was sent", last(h.sent) == "Hola amigo", last(h.sent))
	check("one send is one request", #h.calls == 1, #h.calls)
	check("openrouter untouched while google works", #h.calls == googleCalls(h))

	-- manual translate: one google call, language comes from google
	local m = newHarness({ google = true })
	receive(m, 99, "Ok, eu vou dar peixe.")
	m.CHAT.manualTranslate(m.CHAT.messages[1])
	check("manual translate uses google", #m.calls == 1 and googleCalls(m) == 1, #m.calls)
	check("google detected the language", m.CHAT.messages[1].lang == "pt", m.CHAT.messages[1].lang)
	check("google gave the english line",
		m.CHAT.messages[1].translated == "Ok, I will give fish.", m.CHAT.messages[1].translated)

	-- replying through google lands in the answered language
	local r = newHarness({ google = true })
	receive(r, 77, "Eae mano, bora")
	r.CHAT.replyTo(r.CHAT.messages[1])
	r.CHAT.enqueueSend("ok i will give you the fish")
	check("reply via google goes out in their language", last(r.sent) == "Ok, eu vou dar o peixe.", last(r.sent))
	check("reply never touched openrouter", googleCalls(r) == #r.calls, #r.calls)
	check("reply learned the language", r.LANG.playerLang[77] == "pt", r.LANG.playerLang[77])

	------------------------------------------------------------------
	-- google limited: openrouter takes over, and google is not retried
	------------------------------------------------------------------
	local g = newHarness({ google = true, googleStatus = 429 })
	g.CHAT.setSpeakLang("es")
	g.CHAT.enqueueSend("hello friend")
	check("429 still sends through the fallback", last(g.sent) == "Hola amigo", last(g.sent))
	check("the fallback is openrouter",
		string.find(tostring(last(g.calls).Url), "openrouter.ai", 1, true) ~= nil)
	check("google was rested", g.GOOGLE.available() == false)

	local afterRest = #g.calls
	g.CHAT.enqueueSend("another hello")
	check("next send skips google entirely", googleCalls(g) == 1, googleCalls(g))
	check("next send is one request", #g.calls - afterRest == 1, #g.calls - afterRest)
	check("next send went to openrouter",
		string.find(tostring(last(g.calls).Url), "openrouter.ai", 1, true) ~= nil)

	-- it can be switched off outright
	local off = newHarness({ google = true, respond = function(req)
		local url = tostring(req.Url)
		if string.find(url, "translate.googleapis.com", 1, true) then
			return { StatusCode = 200, Body = '[[["Hola amigo",null,null,null,1]],null,"en"]' }
		end
		return { StatusCode = 200, Body = "Hola amigo" }
	end })
	off.GOOGLE.rest(1000000000, "rested")
	off.CHAT.setSpeakLang("es")
	off.CHAT.enqueueSend("hello there")
	check("a rested google is not called at all", googleCalls(off) == 0, googleCalls(off))
	check("rested google still sends via openrouter", last(off.sent) == "Hola amigo", last(off.sent))
end

----------------------------------------------------------------------
-- 12. keys.json: the Keys tab, and rotation through the saved keys
----------------------------------------------------------------------
do
	local h = newHarness({
		files = { ["keys.json"] = '{\n\t"keys": ["sk-or-v1-jsonaaaaaaaaaaaaaaaa", "sk-or-v1-jsonbbbbbbbbbbbbbbbb"]\n}' },
		genv = { OPENROUTER_KEYS = { "sk-or-v1-genvcccccccccccccccc" } },
		respond = function(req)
			local auth = tostring(req.Headers["Authorization"])
			if auth == "Bearer sk-or-v1-genvcccccccccccccccc"
				or auth == "Bearer sk-or-v1-jsonaaaaaaaaaaaaaaaa" then
				return { StatusCode = 429, Body = '{"error":"rate limit"}', Headers = { ["retry-after"] = "30" } }
			end
			return { StatusCode = 200, Body = "Hola amigo" }
		end,
	})
	check("one model only: openrouter/free", #h.API.models == 1 and h.API.models[1] == "openrouter/free",
		table.concat(h.API.models, ","))

	local keys = h.API.keys()
	check("keys.json keys are read", keys[2] == "sk-or-v1-jsonaaaaaaaaaaaaaaaa"
		and keys[3] == "sk-or-v1-jsonbbbbbbbbbbbbbbbb", tostring(keys[2]) .. "," .. tostring(keys[3]))
	check("a genv key still comes first", keys[1] == "sk-or-v1-genvcccccccccccccccc", keys[1])

	h.CHAT.setSpeakLang("es")
	h.CHAT.enqueueSend("hello friend")
	check("a limited key hands the same request on", last(h.sent) == "Hola amigo", last(h.sent))
	check("the next saved key answers", tostring(last(h.calls).Headers["Authorization"]) == "Bearer sk-or-v1-jsonbbbbbbbbbbbbbbbb")

	local added, msg = h.API.addKey("sk-or-v1-newkeydddddddddddddddd")
	check("a key added in the panel is accepted", added == true, msg)
	check("the new key is written to keys.json",
		string.find(tostring(h.files["keys.json"]), "sk-or-v1-newkeydddddddddddddddd", 1, true) ~= nil)
	check("the new key joins the rotation", h.API.keys()[4] == "sk-or-v1-newkeydddddddddddddddd", h.API.keys()[4])
	check("keys.json stays one key per entry",
		select(2, string.gsub(tostring(h.files["keys.json"]), '"sk%-or%-', "")) == 3,
		tostring(h.files["keys.json"]))

	local again, againMsg = h.API.addKey("sk-or-v1-newkeydddddddddddddddd")
	check("the same key is not saved twice", again == false, againMsg)

	local junk, junkMsg = h.API.addKey("not-a-key")
	check("something that is not sk- is refused", junk == false, junkMsg)

	local removed = h.API.removeKey("sk-or-v1-jsonaaaaaaaaaaaaaaaa")
	check("a saved key can be removed", removed == true)
	check("removed key leaves the rotation",
		not string.find(table.concat(h.API.keys(), ","), "sk-or-v1-jsonaaaaaaaaaaaaaaaa", 1, true))
	check("removed key leaves keys.json",
		not string.find(tostring(h.files["keys.json"]), "sk-or-v1-jsonaaaaaaaaaaaaaaaa", 1, true))

	local noFs = newHarness({ noFiles = true })
	local okNoFs, whyNoFs = noFs.API.addKey("sk-or-v1-newkeydddddddddddddddd")
	check("an executor without files says so instead of pretending",
		okNoFs == false and string.find(tostring(whyNoFs), "write", 1, true) ~= nil, whyNoFs)
end

print("")
print(string.format("%d passed, %d failed", pass, fail))
if fail > 0 then
	process.exit(1)
end
