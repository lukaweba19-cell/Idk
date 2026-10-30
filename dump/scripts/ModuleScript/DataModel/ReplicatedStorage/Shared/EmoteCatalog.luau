-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiled using ByteFall
-- discord.gg/pHTnqmmWzk
local t1: {[any]: any} = {
	Sneaky = {
		Id = "Sneaky",
		Name = "Sneaky",
		Rarity = "Epic",
		Anim = 126891799056222,
		Loop = true,
		Walkable = true,
		Sfx = 123371596334316,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://102994900416028",
		Untradeable = true,
		Description = "They may or may not hear you coming."
	},
	Excited = {
		Id = "Excited",
		Name = "Excited",
		Rarity = "Uncommon",
		Anim = 80209936421806,
		Loop = true,
		Walkable = false,
		Sfx = 85746248721482,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://127405619009874",
		Untradeable = true,
		Description = "Yeah!"
	},
	Laugh = {
		Id = "Laugh",
		Name = "Laugh",
		Rarity = "Rare",
		Anim = 138994027257313,
		Loop = true,
		Walkable = false,
		Sfx = 104907344012316,
		SfxVolume = 0.65,
		SfxPitch = 1.2,
		Icon = "rbxassetid://94986387257922",
		Untradeable = true,
		Description = "That's hilarious."
	},
	PartyTime = {
		Id = "PartyTime",
		Name = "Party Time",
		Rarity = "Rare",
		Anim = 74461879632976,
		Loop = true,
		Walkable = false,
		Sfx = 89943397605204,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://98836729129902",
		Untradeable = true,
		Description = "PBJ!"
	},
	Salute = {
		Id = "Salute",
		Name = "Salute",
		Rarity = "Uncommon",
		Anim = 133213471103509,
		Loop = false,
		Walkable = false,
		Sfx = 74282462913390,
		SfxVolume = 0.5,
		Icon = "rbxassetid://107009366823149",
		Untradeable = true,
		Description = "At ease, soldier."
	},
	Carefree = {
		Id = "Carefree",
		Name = "Carefree",
		Rarity = "Epic",
		Anim = 134860328108401,
		Loop = true,
		Walkable = true,
		Sfx = 90895986469644,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://107304296240990",
		Untradeable = true,
		Description = "Not a worry in the world."
	},
	TakeTheL = {
		Id = "TakeTheL",
		Name = "Take the L",
		Rarity = "Legendary",
		Anim = 80162106397498,
		Loop = true,
		Walkable = false,
		Sfx = 104375125632861,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://89896362882316",
		Untradeable = true,
		Description = "Haha!"
	},
	Strut = {
		Id = "Strut",
		Name = "Strut",
		Rarity = "Rare",
		Anim = 118481578712794,
		Loop = true,
		Walkable = true,
		Sfx = 88467771584513,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://92153788723034",
		Untradeable = true,
		Description = "One step at a time."
	},
	Shy = {
		Id = "Shy",
		Name = "Shy",
		Rarity = "Uncommon",
		Anim = 125429858669234,
		Loop = false,
		Walkable = false,
		Icon = "rbxassetid://113229262477447",
		Untradeable = true,
		Description = "Please don't look."
	},
	Scared = {
		Id = "Scared",
		Name = "Scared",
		Rarity = "Uncommon",
		Anim = 109024198210421,
		Loop = true,
		Walkable = false,
		Sfx = 118068070222822,
		SfxVolume = 0.5,
		SfxFadeOutAt = 5,
		SfxFadeTime = 0.6,
		Icon = "rbxassetid://73685364869727",
		Untradeable = true,
		Description = "Something's behind you."
	},
	QuickStep = {
		Id = "QuickStep",
		Name = "Quick Step",
		Rarity = "Rare",
		Anim = 124148740769405,
		Loop = true,
		Walkable = false,
		Sfx = 73615797334819,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://90461409613373",
		Untradeable = true,
		Description = "Fast feet, or legs?"
	},
	Penguin = {
		Id = "Penguin",
		Name = "Penguin",
		Rarity = "Epic",
		Anim = 89377275439920,
		Loop = true,
		Walkable = true,
		Sfx = 100132902840970,
		SfxVolume = 0.5,
		SfxPitchVar = 0.14,
		Icon = "rbxassetid://83606744672940",
		Untradeable = true,
		Description = "Waddle waddle waddle."
	},
	Icon = {
		Id = "Icon",
		Name = "Default",
		Rarity = "Common",
		Anim = 88358405952885,
		Loop = false,
		Walkable = false,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://72663021862400",
		Untradeable = true,
		Description = "Seems familiar..",
		Sfx = { 131019007527030, 93100628241919 }
	},
	CrazyJump = {
		Id = "CrazyJump",
		Name = "Crazy Jump",
		Rarity = "Legendary",
		Anim = 116161186682963,
		Loop = true,
		Walkable = false,
		Sfx = 110001723445025,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://92807457056655",
		Untradeable = true,
		Description = "Go crazy."
	},
	CatGIF = {
		Id = "CatGIF",
		Name = "Cat GIF",
		Rarity = "Epic",
		Anim = 135787516496429,
		Loop = true,
		Walkable = false,
		Sfx = 112256290726828,
		SfxVolume = 0.35,
		MusicDuck = 0.1,
		Icon = "rbxassetid://79465802956166",
		Untradeable = true,
		Description = "Vibing since the dawn of the internet."
	},
	Breakdance = {
		Id = "Breakdance",
		Name = "Breakdance",
		Rarity = "Rare",
		Anim = 133368166779993,
		Loop = false,
		Walkable = false,
		Sfx = 136546773180813,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://132167046569818",
		Untradeable = true,
		Description = "Clear the floor."
	},
	Backflip = {
		Id = "Backflip",
		Name = "Backflip",
		Rarity = "Uncommon",
		Anim = 125786982426366,
		Loop = true,
		Walkable = false,
		Sfx = 99101524055339,
		SfxVolume = 0.5,
		SfxPitchVar = 0.08,
		Icon = "rbxassetid://116761662568530",
		Untradeable = true,
		Description = "Where'd you learn that?"
	},
	Thirsty = {
		Id = "Thirsty",
		Name = "Thirsty",
		Rarity = "Rare",
		Anim = 129156149605887,
		Loop = false,
		Walkable = false,
		Sfx = 86359948996565,
		SfxVolume = 0.5,
		SfxTail = true,
		Icon = "rbxassetid://101639232640768",
		Untradeable = true,
		Description = "Stay hydrated.",
		Prop = { Name = "Cola", AttachAt = 0.45, DetachAt = 3.8 }
	},
	MonsterMash = {
		Id = "MonsterMash",
		Name = "Monster Mash",
		Rarity = "Rare",
		Anim = 74078495295892,
		Loop = true,
		Walkable = false,
		Sfx = 100290840411320,
		SfxVolume = 0.5,
		SfxPitch = 0.85,
		AnimSpeed = 0.85,
		MusicDuck = 0.1,
		Icon = "rbxassetid://87211947253452",
		Untradeable = true,
		NotSold = true,
		Description = "Keeping it real since 2010"
	},
	WitchesBrew = {
		Id = "WitchesBrew",
		Name = "Witches Brew",
		Rarity = "Rare",
		Anim = 129156149605887,
		Loop = false,
		Walkable = false,
		Sfx = 86359948996565,
		SfxVolume = 0.5,
		SfxTail = true,
		Icon = "rbxassetid://112277198790654",
		Untradeable = true,
		NotSold = true,
		Description = "boo!",
		Prop = { Name = "WitchesBrew", AttachAt = 0.45, DetachAt = 3.8 },
		Fx = {
			Name = "BrewHead",
			At = 3.35,
			Sound = 113655648022851,
			SoundVolume = 0.6,
			Scale = 2.4,
			HoldAfter = 2.5
		}
	},
	Breakbeat = {
		Id = "Breakbeat",
		Name = "Breakbeat",
		Rarity = "Epic",
		Anim = 70921014543491,
		Loop = true,
		Walkable = false,
		Sfx = 107661833751223,
		SfxVolume = 0.5,
		MusicDuck = 0.1,
		Icon = "rbxassetid://83725955963339",
		Untradeable = true,
		NotSold = true,
		Description = "you were here."
	},
	Headless = {
		Id = "Headless",
		Name = "Headless",
		Rarity = "Uncommon",
		Anim = 88422202698252,
		Loop = false,
		Walkable = false,
		Sfx = 125016544242371,
		SfxVolume = 0.5,
		Icon = "rbxassetid://130671463305504",
		Untradeable = true,
		NotSold = true,
		Description = "Lost your head?"
	}
}

local module: {[any]: any} = {
	WALK_MULT = 0.4,
	SLOTS = 8,
	UNIQUE = true,
	DEFAULT_ID = "Icon",
	Defs = t1,
	Order = {
		"Sneaky",
		"Excited",
		"Laugh",
		"PartyTime",
		"Salute",
		"Carefree",
		"TakeTheL",
		"Strut",
		"Shy",
		"Scared",
		"QuickStep",
		"Penguin",
		"Icon",
		"CrazyJump",
		"CatGIF",
		"Breakdance",
		"Backflip",
		"Thirsty",
		"MonsterMash",
		"WitchesBrew",
		"Breakbeat",
		"Headless"
	},
	AnimSpeed = function(p1)
		local animSpeed = p1 and p1.AnimSpeed

		if typeof(animSpeed) == "number" and animSpeed > 0 then
			return animSpeed
		end

		return 1
	end,
	Get = function(p2)
		if typeof(p2) == "string" then
			return t1[p2]
		end

		return nil
	end
}

function module.Exists(p3)
	return module.Get(p3) ~= nil
end

return module
