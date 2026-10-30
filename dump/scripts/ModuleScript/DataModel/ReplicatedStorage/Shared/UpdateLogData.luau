-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local updateGate = require(script.Parent:WaitForChild("UpdateGate"))

local module: {[any]: any} = {
	Updates = {
		{
			id = 15,
			name = "Halloween Update",
			date = "10/17/2026",
			releaseAt = 1792260000,
			headerImage = "rbxassetid://110442568799226",
			paragraphs = {
				"👻 <b>The Halloween Update is here!</b> A brand new Halloween Battle Pass, the Hallow’s Case, the Headless Horseman’s Wheel, two new abilities, a new map and more.",
				"<b>NEW CHANGES:</b>",
				"● New Halloween Battle Pass (Season 2)!<br />   ○ 16 tiers of Halloween rewards on the Free and Premium paths<br />● New Hallow’s Case with Halloween skins and Secrets<br />● New bundles; Vampiric &amp; Black Cat!<br />● <b>NEW COLLECTIBLE</b>: Devil’s Sight: <b>Only 99 copies</b>, hidden in the Hallow’s Case!<br />● The Headless Horseman’s has arrived, and he has brought his wheel of familiar prizes is in the lobby - spin it with Wheel Tickets from the Halloween Pass or the shop!<br />● Two NEW Skills: <b>Dash</b> and <b>Rewind</b><br />● Explosive Skill has been reworked!<br />● New Map: <b>Backrooms</b><br />● A few maps have been altered for the spooky season!<br />● Duel pads can now start with uneven teams (like 2v1) once the smaller team readies up<br />● Molotov fire is now green for your team and red for enemies<br />● The Space Case has left the shop (any you own can still be opened)<br />● Even more coming next week!<br />● General bug fixes, balancing, and polish"
			}
		},
		{
			id = 14,
			name = "The Plague",
			date = "10/11/2026",
			headerImage = "rbxassetid://125129132591207",
			paragraphs = {
				"As the <b>Halloween Update</b> creeps closer, a strange figure has appeared in the lobby. <b>The Plague Doctor</b> has arrived, bringing exclusive rewards for anyone willing to spread the plague. ☣️",
				"Every kill counts toward the Plague Doctor's rewards: the <b>Infected</b> knife at <b>50 kills</b>, the <b>Outbreak</b> finisher at <b>150 kills</b>, and the <b>Infector</b> gun at <b>300 kills</b>. Each reward has a <b>1% chance</b> to be its rare <font color=\"#c77dff\"><b>Purple</b></font> variant. Once you've earned all three, the plague starts over and the odds go up every round, all the way to <b>10%</b>."
			}
		},
		{
			id = 13,
			name = "Emotes",
			date = "9/14/2026",
			headerImage = "rbxassetid://111001589899240",
			paragraphs = {
				"<b>Emotes</b> have arrived! 🕺 A small update this time: a brand new way to express yourself in the lobby and in matches.",
				"<b>NEW CHANGES:</b>",
				"● New <b>Emotes</b> - hold <b>B</b> (or use the new mobile button) to open your emote wheel<br />● Everyone has been given a <b>free emote</b> - check your <b>Inventory</b> to equip it<br />● New <b>Daily</b> section in the <b>Shop</b> with <b>6 emotes</b> that rotate every day<br />● Emotes can be gifted to friends and previewed before you buy<br />● General bug fixes and polish",
				"More <b>free emotes</b> are coming in future updates, so keep an eye on the Daily shop. Let us know which ones you'd like to see next in our <b>Community server</b>! 🎉"
			}
		},
		{
			id = 12,
			name = "Trading Update Part 2",
			date = "9/7/2026",
			releaseAt = 1788803940,
			headerImage = "rbxassetid://118466785983182",
			paragraphs = {
				"<b>Trading</b> just got a huge upgrade!",
				"<b>NEW CHANGES:</b>",
				"● <b>Booths</b> are now available in the <b>Trading Plaza</b> - list and sell items at your own prices (Trade Tokens)<br />● <b>RAP (Recent Average Price)</b> now shows the live value of tradeable items<br />● New <b>Item Index</b> to browse items, favorite them, and view RAP history<br />● Overhauled <b>Trade</b> screen with live value comparisons<br />● New <b>Trade Chat</b> and <b>Trade History</b><br />● New limited <b>Railgun Z1</b> Collectible with a <b>Black Hole</b> finisher<br />● General bug fixes, balancing, and polish",
				"Set up your booth, check your RAP, and let us know what you think in our <b>Community server</b>. Happy trading!"
			}
		},
		{
			id = 11,
			name = "Shipyard Update",
			date = "8/30/2026",
			headerImage = "rbxassetid://90602174015109",
			paragraphs = {
				"A new map, new bundles, balance changes, and more have arrived! ⚓ Explore the reworked <b>Shipyard</b>, chase new bundle variants, and check out the latest gameplay improvements.",
				"<b>NEW CHANGES: </b>",
				"● New <b>Shipyard</b> map: a full rework of Proto, which it now replaces<br />● New <b>Energy Bundle</b>: choose between <font color=\"#ff5555\">Red</font>, <font color=\"#55ff55\">Green</font>, or <font color=\"#5599ff\">Blue</font>, with a <b>1% chance</b> to receive the rare <b>Omega</b> variant<br />● New <b>Heart Keeper Bundle</b>, with a <b>10% chance</b> to receive the <b>Heart Stealer</b> variant<br />● <b>Explosive Knife</b> has been nerfed<br />● New <b>anti-exploit changes</b> and security improvements<br />● General bug fixes, polishing, and improvements",
				"Thanks for playing and supporting the game! We’ve got plenty more planned and can’t wait to share what’s next. 🎉"
			}
		},
		{
			id = 9,
			name = "Summer Update Part 2",
			date = "8/2/2026",
			headerImage = "rbxassetid://102075460975083",
			paragraphs = {
				"The <b>Summer Update (Part 2)</b> is here! ☀️ Introducing the brand-new <b>Summer Pass</b>, featuring two reward paths packed with exclusive items to unlock as you play.",
				"<b>NEW CHANGES:</b>",
				"● Introducing the brand-new <b>Summer Pass</b><br />   ○ Earn <b>EXP</b> by playing to progress through the pass<br />   ○ Unlock <b>15 rewards</b> through the Free path<br />   ○ Upgrade to Premium to unlock an additional <b>15 rewards</b><br />   ○ Claim exclusive limited-time cosmetics and other valuable rewards before the pass ends<br />● Added a new <b>Exclusive</b> rarity tier for certain special items<br />● Fixed an issue that could cause the in-game chat to stop working properly<br />● As a bonus to celebrate 100M visits, redeem code <b>100MOG</b> to receive the <b>OG Knife</b><br />● Additional bug fixes, improvements, and overall polish",
				"Jump in, earn EXP, and work your way through the Summer Pass to claim all of its limited-time rewards before the season comes to an end. We hope you enjoy Part 2, and there's still more summer content on the way!"
			}
		},
		{
			id = 8,
			name = "Summer Update Part 1",
			date = "7/26/2026",
			headerImage = "rbxassetid://104657504686448",
			paragraphs = {
				"The <b>Summer Update (Part 1)</b> is here! 🎉 Explore the fully reworked lobby, battle across new maps, customize your crosshair, discover exclusive new <b>Collectibles</b>, and check out improvements across the entire game.",
				"<b>NEW CHANGES:</b>",
				"● The <b>Lobby</b> has been completely reworked with a brand new layout and visuals<br />● Added two new maps: <b>Facility</b> and <b>House</b><br />● <b>Lumber</b> has received a full rework, while <b>Express</b> has been phased out due to low demand<br />● Added a new <b>Crosshair Editor</b>, allowing you to fully customize your crosshair<br />● Mobile players can now resize their controls through the <b>Settings</b> menu<br />● Added two new limited-time <b>Bundles</b><br />● Introducing <b>Collectibles</b>: exclusive limited drops with unique VFX and individually numbered serials<br />● The first-ever Collectible, the <b>Chroma Sniper</b>, is now available in limited quantities<br />● The <b>Trading Plaza</b> has been finalized with a new shooting range, additional visuals, and more polish<br />● Added <b>Top Clans Podiums</b> to the lobby, showcasing the current top five clans. Top Clan rewards are coming soon<br />● Economy improvements, including rebalanced skill costs, Coin products, and a buffed <b>Starter Pack</b><br />● Additional bug fixes, balancing, and overall polish",
				"Thank you for all the feedback and support. This update brings major improvements across nearly every part of the game, and there's still much more on the way. We hope you enjoy the new lobby, maps, Collectibles, and everything else included in the update!"
			}
		},
		{
			id = 7,
			name = "Trading Update",
			date = "7/5/2026",
			headerImage = "rbxassetid://135495022788620",
			paragraphs = {
				"<b>Trading</b> has officially arrived! 🤝 Visit the new <b>Trading Plaza</b>, earn <b>Trade Tokens</b>, and discover the brand new <b>Space Case</b> featuring exclusive cosmetics and secrets.",
				"<b>NEW CHANGES:</b>",
				"● <b>Trading</b> is now live, along with the new <b>Trading Plaza</b><br />● Earn <b>Trade Tokens</b> from trades and spend them anywhere <b>Robux</b> is accepted at a <b>1:1 value</b><br />● New <b>Space Case</b> with exclusive cosmetics and brand new <b>Secret</b> items<br />● The <b>Founders Case</b> has been discontinued and is no longer obtainable<br />● Bug fixes, balancing, and overall polish",
				"Thank you for all the feedback and patience while we worked on Trading. We can't wait to see the trades you'll make, and we've already got more content on the way. Happy trading! 🚀"
			}
		},
		{
			id = 6,
			name = "Fourth of July",
			date = "6/26/2026",
			headerImage = "rbxassetid://116887982713095",
			paragraphs = {
				"The <b>Fourth of July</b> event has arrived! 🎆 Complete daily challenges to unlock exclusive holiday skins.",
				"<b>NEW CHANGES: </b>",
				"● Limited-time <b>Fourth of July</b> event with new holiday skins to unlock<br />● <b>Finishers</b> are now their own items you can apply to any weapon<br />● New <b>Finishers Case</b> available in the shop<br />● <b>Clan</b> owners can now upgrade their member limit<br />● Bug fixes, balancing, and overall polish<br />●<b> Trading</b> is nearly completed, and will release <b>next Friday</b>",
				"The event runs for a limited time, so jump in and finish your challenges before it ends! More content and updates are already on the way. Let us know what you'd like to see next in our <b>Community server</b>! 🎉"
			}
		},
		{
			id = 5,
			name = "Matchmaking Beta",
			date = "6/12/2026",
			headerImage = "rbxassetid://121632654227341",
			paragraphs = {
				"<b>Matchmaking</b> has arrived in beta! ⚔️ Queue up, party with friends, and jump into matches more smoothly than before.",
				"<b>NEW CHANGES: </b>",
				"● New <b>Matchmaking</b> system <font transparency=\"0.5\">(Beta)</font><br />● <b>Clan Leaderboards</b> are now live<br />● New map: <b>Express</b><br />● <b>Parties</b> have been reworked<br />● New bundles: <b>Megalodon</b> and <b>Mermaid</b><br />● The <b>Release Pack</b> has been replaced<br />● Bug fixes, polishing, and overall improvements",
				"This is only the start for <b>Matchmaking</b> and <b>Clans</b>! More improvements, competitive features, and content are already on the way. Let us know what you'd like to see next in our <b>Community server</b>! 🎉"
			}
		},
		{
			id = 4,
			name = "Clans Beta",
			date = "6/5/2026",
			headerImage = "rbxassetid://124049454941751",
			paragraphs = {
				"<b>Clans</b> have arrived! 🛡️ Team up under one tag, recruit your friends, and rep your crew.",
				"<b>NEW CHANGES: </b>",
				"● Create or join a <b>Clan</b> and recruit other players<br />● Your <b>Clan Tag</b> shows on your character and in chat<br />● Check out any player's clan right from their profile card<br />● <b>Ricochet</b> balancing, plus general bug fixes and polish",
				"This is only the first phase of <b>Clans</b>! Clan leaderboards, competitive rankings, and more clan-focused features are coming soon. For now, gather your crew, claim your tag, and let us know what you'd like to see next in our <b>Community server</b>! 🎉"
			}
		},
		{
			id = 3,
			name = "Release Patch 2",
			date = "5/22/2026",
			headerImage = "rbxassetid://136424178345909",
			paragraphs = {
				"<b>Murder Duels</b> keeps evolving! 🎉 This patch introduces a new revolver skill, another experimental map, and more polish as we continue improving the overall experience.",
				"<b>NEW CHANGES: </b>",
				"● New Revolver Skill: <b>Frost Rounds</b><br />● Experimental map: <b>Proto</b><br />● New <b>Friend Boost</b> perks<br />● Bug fixes, balancing, and overall polish",
				"More content is already on the way. Be sure to share any bugs or feedback in our <b>Community server</b>!"
			}
		},
		{
			id = 2,
			name = "Release Patch 1",
			date = "5/15/2026",
			headerImage = "rbxassetid://134908780153092",
			paragraphs = {
				"Thank you for playing <b>Murder Duels</b>! ❤️ This first patch is mainly focused on polishing the game and fixing issues before the bigger content updates begin rolling out.",
				"<b>NEW CHANGES: </b>",
				"● <b>Location pinging</b> <font transparency=\"0.5\">(Middle Click — PC only for now)</font><br />● Experimental map: <b>Template</b><br />● General fixes and adjustments",
				"Bugs or feedback? Drop them in our <b>Community server</b>. Happy playing! 🎉"
			}
		},
		{
			id = 1,
			name = "Beta Release",
			date = "5/12/2026",
			headerImage = "rbxassetid://91966325499196",
			paragraphs = { "The game has officially launched in <b>beta</b>." }
		}
	},
	IsReleased = function(p1)
		local releaseAt = p1.releaseAt

		if typeof(releaseAt) == "number" then
			local v5 = updateGate.GetCurrentTime()

			return releaseAt <= v5
		end

		return true
	end
}

function module.GetVisible()
	local t2: {[any]: any} = {}

	for _, v in ipairs(module.Updates) do
		if module.IsReleased(v) then
			table.insert(t2, v)
		end
	end

	return t2
end
function module.GetLatestId()
	local n1 = 0

	for _, v in ipairs(module.Updates) do
		if v.id and n1 < v.id and module.IsReleased(v) then
			n1 = v.id
		end
	end

	return n1
end

return module
