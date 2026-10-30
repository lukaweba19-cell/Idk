-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {
	"Swift",
	"Brave",
	"Lucky",
	"Silent",
	"Mighty",
	"Rapid",
	"Cosmic",
	"Frosty",
	"Sneaky",
	"Turbo",
	"Wild",
	"Calm",
	"Bold",
	"Clever",
	"Daring",
	"Eager",
	"Fancy",
	"Gentle",
	"Happy",
	"Jolly",
	"Keen",
	"Lively",
	"Merry",
	"Noble",
	"Plucky",
	"Quick",
	"Rowdy",
	"Sunny",
	"Tidy",
	"Vivid",
	"Witty",
	"Zesty",
	"Bouncy",
	"Breezy",
	"Chilly",
	"Crafty",
	"Dandy",
	"Dusty",
	"Epic",
	"Fierce",
	"Fluffy",
	"Foggy",
	"Fuzzy",
	"Grand",
	"Hasty",
	"Hyper",
	"Icy",
	"Jazzy",
	"Loyal",
	"Lunar",
	"Magic",
	"Mellow",
	"Misty",
	"Nimble",
	"Peppy",
	"Perky",
	"Prime",
	"Proud",
	"Quirky",
	"Regal",
	"Shiny",
	"Sleek",
	"Snappy",
	"Solar"
}
local t2: {[any]: any} = {
	"Amber",
	"Aqua",
	"Azure",
	"Berry",
	"Blue",
	"Bronze",
	"Cherry",
	"Cobalt",
	"Copper",
	"Coral",
	"Crimson",
	"Cyan",
	"Ember",
	"Emerald",
	"Gold",
	"Hazel",
	"Indigo",
	"Ivory",
	"Jade",
	"Lava",
	"Lemon",
	"Lilac",
	"Lime",
	"Magenta",
	"Mango",
	"Maroon",
	"Mint",
	"Navy",
	"Neon",
	"Olive",
	"Onyx",
	"Opal",
	"Orange",
	"Pearl",
	"Pine",
	"Plum",
	"Ruby",
	"Rust",
	"Sage",
	"Sand",
	"Scarlet",
	"Silver",
	"Slate",
	"Snow",
	"Teal",
	"Topaz",
	"Violet",
	"Zinc"
}
local t3: {[any]: any} = {
	"Otter",
	"Falcon",
	"Badger",
	"Bison",
	"Cobra",
	"Condor",
	"Coyote",
	"Crane",
	"Dingo",
	"Dolphin",
	"Dragon",
	"Eagle",
	"Ferret",
	"Finch",
	"Fox",
	"Gecko",
	"Gopher",
	"Hawk",
	"Heron",
	"Hornet",
	"Husky",
	"Ibex",
	"Iguana",
	"Jackal",
	"Jaguar",
	"Koala",
	"Lemur",
	"Lynx",
	"Macaw",
	"Mammoth",
	"Manta",
	"Marlin",
	"Meerkat",
	"Moose",
	"Narwhal",
	"Newt",
	"Ocelot",
	"Orca",
	"Osprey",
	"Owl",
	"Panda",
	"Panther",
	"Parrot",
	"Pelican",
	"Penguin",
	"Phoenix",
	"Pigeon",
	"Puffin",
	"Puma",
	"Python",
	"Rabbit",
	"Raccoon",
	"Raven",
	"Rhino",
	"Robin",
	"Salmon",
	"Shark",
	"Sparrow",
	"Tiger",
	"Toucan",
	"Viper",
	"Walrus",
	"Wombat",
	"Zebra"
}

local function djb2(p1)
	local n1 = 5381

	for i = 1, #p1 do
		local v8 = string.byte(p1, i)

		n1 = (n1 * 33 + v8) % 4294967296
	end

	return n1
end

return {
	fromJobId = function(p2)
		local randomNew = Random.new
		local n1 = 5381

		for i = 1, #p2 do
			local v13 = string.byte(p2, i)

			n1 = (n1 * 33 + v13) % 4294967296
		end

		local v14 = randomNew(n1)
		local v15 = v14:NextInteger(1, #t1)
		local v16 = t1[v15]
		local v17 = v14:NextInteger(1, #t2)
		local v18 = t2[v17]
		local v19 = v14:NextInteger(1, #t3)

		return v16 .. v18 .. t3[v19]
	end
}
