--[[
		Thank you for using UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

		IMPORTANT: Original Source of these Scripts was RECOVERED: ["Workspace.Lobby.CheapPack.PlayAnimation","Workspace.Lobby.PremiumCase.PlayAnimation","Workspace.Lobby.RegularCase.PlayAnimation","Workspace.Lobby.FinishersCase.PlayAnimation","Workspace.Lobby.FinishersCase.Noob.PlayAnimation","Workspace.Lobby.FelkusKitten.PlayAnimation","Workspace.Horseman.PlayAnimation","ReplicatedStorage.FX.CaseOpens.PremiumCase.PlayAnimation","ReplicatedStorage.FX.CaseOpens.FinishersCase.PlayAnimation","ReplicatedStorage.FX.CaseOpens.SpaceCase.PlayAnimation","ReplicatedStorage.FX.CaseOpens.HallowsCase.PlayAnimation","ReplicatedStorage.ExpensivePack.PlayAnimation","ReplicatedStorage.HallowsUpsell.PlayAnimation","StarterGui.HUD.Camera.spring"]

		!! GETHIDDENPROPERTY ISSUES !!
		Your executor's gethiddenproperty couldn't read these types, so data may be missing or wrong.
		Tell your executor's developers. Affected types:
				Failed reads: ["AssetContentMap","Color3uint8","Enum","NetAssetRef","OptionalCoordinateFrame"]

		ServerStorage, ServerScriptService and Server Scripts are IMPOSSIBLE to save because of FilteringEnabled.

		Images, meshes, textures, sounds etc. failed to load or look invisible? Those assets are private. Try https://github.com/kartFr/Asset-Reuploader or similar.

		Player doesn't spawn? Move or delete the scripts in StarterPlayer, then run game:GetService("Players").CharacterAutoLoads = true
		Use "Play Here" instead of "Play" to spawn where your Camera is.

		Chat broken? Delete everything in TextChatService/Chat, or run game:GetService("Chat"):ClearAllChildren() game:GetService("TextChatService"):ClearAllChildren()

		Union/MeshPart collisions broken? Run this in the Studio Command Bar:


		local C = game:GetService("CoreGui")
		local E = Enum.CollisionFidelity:GetEnumItems()
		local O = {}

		for _, v in game:GetDescendants() do
			if v:IsA("TriangleMeshPart") and not v:IsDescendantOf(C) then
				local c = v.CollisionFidelity
				O[v] = c
				v.CollisionFidelity = E[1] ~= c and E[1] or E[2]
			end
		end

		for v, c in O do
			v.CollisionFidelity = c
		end
		print("Done")

		Camera stuck? Run this in the Studio Command Bar:

		workspace.CurrentCamera.CameraType = Enum.CameraType.Fixed

		Or destroy the Camera.

		Settings:
		{"SavePlayerCharacters":false,"CompressionLevel":9,"Callback":false,"ShowStatus":true,"IgnoreDefaultPlayerScripts":false,"NilInstancesFixes":{"BaseWrap":null,"Animator":null,"Attachment":null,"PackageLink":null,"AdPortal":null},"IgnoreList":["CoreGui","CorePackages"],"__DEBUG_MODE":false,"KillAllScripts":false,"DecompileJobless":false,"Binary":true,"Decompile":true,"IgnoreNotArchivable":true,"OptionsAliasesInverse":{"RemovePlayerCharacters":"SavePlayerCharacters","DisableCompression":"CompressionMode","NullifyScripts":"Decompile","noscripts":"Decompile","XML":"Binary","RemovePlayers":"IsolatePlayers"},"RecoverScriptsFromAssets":true,"DecompileIgnore":["TextChatService"],"IgnoreSpecialProperties":false,"BoostFPS":false,"IsModel":false,"NilInstances":false,"OptionsAliases":{"DecompileScripts":"Decompile","SaveCharacters":"SavePlayerCharacters","EmbedBytecode":"SaveBytecode","Clipboard":"CopyToClipboard","InstancesBlacklist":"IgnoreList","IsolatePlayerGui":"IsolateLocalPlayer","IgnoreDefaultProps":"IgnoreDefaultProperties","timeout":"DecompileTimeout","FileName":"FilePath","StatusText":"ShowStatus","IgnoreArchivable":"IgnoreNotArchivable","SavePlayerGui":"IsolateLocalPlayer","SaveNilInstances":"NilInstances","SaveLocalPlayer":"IsolateLocalPlayer","SaveNonCreatable":"SaveNotCreatable","SavePlayers":"IsolatePlayers","Path":"FilePath","ShowProgress":"ShowStatus"},"IsolateLocalPlayerCharacter":false,"RiskyServicesDisabled":{"Reflection":false,"Encoding":false,"UGC":true},"ExtraInstances":[],"TreatUnionsAsParts":false,"ReadMe":true,"IgnoreProperties":[],"NotCreatableFixes":["","AdvancedDragger","AnimationTrack","Dragger","Player","PlayerGui","PlayerMouse","PlayerScripts","ScreenshotHud","StudioData","TextChatMessage","TextSource","TouchTransmitter","Translator"],"SharedBinaryStrings":false,"IsolateStarterPlayer":false,"DecompileTimeout":10,"IsolatePlayers":false,"AlternativeWritefile":true,"mode":"optimized","SaveCacheInterval":56320,"ShutdownWhenDone":false,"SourceCache":false,"BytecodeTimeout":3,"FilePath":false,"CompressionMode":"zstd","Anonymous":false,"Object":false,"IgnoreDefaultProperties":true,"IgnorePropertiesOfNotScriptsOnScriptsMode":false,"AvoidFileOverwrite":true,"SaveNotCreatable":false,"IsolateLocalPlayer":false,"SafeMode":false,"AntiIdle":true,"CopyToClipboard":false,"SaveBytecode":false,"scriptcache":true}

		Elapsed time: 98.631418 seconds                          
		Date (UTC): 30 October 2026 09:55:38 PlaceId: 120851538706364 PlaceVersion: 7739 Client Version: 2.743.1136 Platform: IOS Executor: Delta 1.0.743.1136 arm64
]]