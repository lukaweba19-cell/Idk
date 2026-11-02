# Murder Duels — what is in the dump, and every script we can build from it

Based on the full decode in `dump/` (59,985 instances, 1,198 scripts, 217 remotes).
Read `dump/README.md` first for provenance: this is a **client-side** save, so the client is
100 % present and the **entire server is missing**. That single fact defines the build plan.

---

## 1. What the game is

A round-based murder-mystery duel game with a heavy cosmetic/economy layer:

- **Lobby** (`Workspace.Lobby`, 21,769 instances) with case podiums, leaderboard boards, trade
  portal, training portals, inspect room, collectible bubble, duel stations, plaza portal.
- **Matches**: roles, knife + revolver, abilities, kill effects, killcam, replay, spectate,
  map vote, win screen, streaks, "makegood" waves, practice mode.
- **Meta**: shop, inventory, case unboxing with reel animation, trading, RAP/index pricing,
  clans, battle pass + season pass, daily gifts/tasks, limited collectibles with serials,
  booth/vending, wheel spin events (Halloween), token/Robux products.
- **Platform**: matchmaking + party + plaza server list, replay recording/playback, admin
  (Cmdr with 260 client commands), analytics hooks, mobile touch controls.

## 2. Recovery status by layer

| Layer | Status | Evidence |
| --- | --- | --- |
| Shared logic / catalogs / configs | ✅ fully recovered | `ReplicatedStorage.Shared` (121 modules), `Catalogs`, `Util` (86) |
| UI controllers | ✅ fully recovered | `StarterGui` (26 GUI roots, 7.7k instances, ~970 KB of controllers) |
| Camera / viewmodel / weapon rig | ✅ recovered | `WeaponRigWatcher`, `ViewmodelArms`, `FOVController`, `ThirdPerson` |
| VFX and finishers | ✅ recovered | `Effect` (379 modules, 81 kill effects), `Util.ForgeVFX`, `Util.Lightning` |
| Abilities (client half) | ✅ recovered | 18 modules + `AbilityCatalog` (15 abilities) |
| Replay codec/actors/UI | ✅ client side | `ReplayFormat` (45 KB), `ReplayCodec`, `ReplayActors`, `ReplayController` (105 KB) |
| Admin command UI/parser | ✅ recovered | `Cmdr` + `CmdrClient` (274 modules) |
| Match server authority | ❌ absent | no `ServerScriptService` |
| Persistence / economy validation | ❌ absent | remotes like `Inventory`, `CurrencyBuyRequest` have no handler |
| Anti-cheat enforcement | ⚠️ client stub only | `StarterPlayerScripts.AntiCheat`, `WeaponAuthDebugDrawClient` |
| Asset binaries | ⚠️ IDs only | private meshes/textures/sounds/animations |

## 3. Systems map (where to look)

| System | Folder | Size |
| --- | --- | --- |
| VFX / finishers / explosions | `ReplicatedStorage.Effect` | 379 mods, 1.12 MB |
| Shared gameplay modules | `ReplicatedStorage.Shared` | 121 mods, 712 KB |
| Utilities (fade, picker, shaker, fracture) | `ReplicatedStorage.Util` | 86 mods, 559 KB |
| Client gameplay scripts | `StarterPlayer.StarterPlayerScripts` | 129 files, 1.15 MB |
| HUD / windows / menus | `StarterGui.HUD` | 41 files, 966 KB |
| Lobby interactables | `Workspace.Lobby` | 24 scripts, 157 KB |
| Abilities | `ReplicatedStorage.Abilities` | 18 mods |
| Catalogs (abilities, clans, season pass) | `ReplicatedStorage.Catalogs` | 3 mods |
| Admin | `ReplicatedStorage.Cmdr` / `CmdrClient` | 14 + 260 mods |
| Matchmaking / party | `ReplicatedStorage.MatchmakingShared`, `PartyRemotes` | 4 mods + 19 remotes |
| Remotes hub | `ReplicatedStorage.Remotes` (117), `Bindables` (63) | — |
| UI toolkit | `ReplicatedStorage.UIFramework`, `Icon` | 3 + 21 mods |

The 117 remotes in `ReplicatedStorage.Remotes` are effectively a **spec of the server API**:
`Inventory`, `PackRequest`, `CaseOpen`-adjacent FX, `Abilities_Request`, `Hit`, `ConsumeHit`,
`DamageNotifyRemote`, `ApplyVelocity`, `TradeEvent`, `Clan`, `SeasonPass`, `DailyRewards_Claim`,
`RedeemCode`, `PlazaServerList`, `ReplaySave`, `ReportPlayer`, `CurrencyBuyRequest`, `Booth`,
`ItemIndex`, `RAP`, `GlobalLeaderboard`, `MatchHistory_Request`, `Shop_DebugGiveItem` …
Build the server against those names and the recovered client just works.

## 4. Everything we can build — by phase

### Phase 0 — make it run
1. `Bootstrap.server.lua` — `CharacterAutoLoads`, lobby spawn, service wiring, remote registry.
2. `RemoteSchema` module — one source of truth for all 117 events + 40 functions, with
   argument type checks and per-player rate limits (the client already expects exact names).
3. Character/lobby loader — ragdoll, viewmodel, camera, spawn formation (`SpawnFormation` module),
   plus the SynSave fixes from `dump/README.md`.

### Phase 1 — match core (the actual game)
4. `RoundStateMachine` — intermission → map vote → role assign → round → win screen → cleanup
   (events already named: `MatchRemotes.State`, `RoundCleanup`, `WinScreenDismiss`, `MapVote`).
5. `RoleService` — Murderer / Sheriff / Innocent, plus duel and practice variants.
6. `WeaponService` — knife throw/flight/timing (`KnifeFlight`, `KnifeTiming`, `KnifeCamPath`,
   `RevolverTiming` are recovered and define the exact curves the client animates).
7. `HitValidation` — server-side swept hitbox checks for `Hit`, `ConsumeHit`, `ReportHit`,
   `ShootReplicate`, `ThrowReplicate`; reject impossible deltas, cooldowns, LOS.
8. `KillService` + killfeed + streaks + `DamageNotifyRemote` (client `DamageNotification` ready).
9. `AbilityService` — 15 abilities from `AbilityCatalog`: Triple/Explosive/Smoke/Portal/Molotov
   knife, Deflect, Bullet Barrage, Ricochet, Rapid Reload, Frost Rounds, Speed Boost, Super Jump,
   Decoy, X-Ray, Dash. Server owns cooldowns and effect authority (`AbilityCastBroadcast`,
   `AbilityEffectSync`, `Abilities_Push`).
10. `FinisherService` — 81 kill effects with rarity/variants; broadcast + own the timeline.
11. `SpectateService`, `KillcamService` (`KillcamTimeline`), `PracticeService` (`ExitPractice`,
    `PracticeNoCooldown`), `DuelStationService` (`DuelStationReady`).

### Phase 2 — economy and persistence
12. `ProfileService` layer (DataStore + session locking) — money, gems/tokens, inventory,
    win streaks, match history, settings, seen-update flags.
13. `InventoryService` + `ItemIndexService` — item keys, serials, RAP (`RapClient`,
    `RapProjected` recovered), and the item-index UI’s expected payloads.
14. `CaseService` — server roll + provable seed, `PeekNextCrateRoll`, `CaseStripSeq`,
    `CaseSpinFeel` driven reel, `PackVariantHit`, dupes → shards.
15. `ShopService` — `ShopOpenAnalytics`, Robux product IDs (`CurrencyProducts`,
    `TokenProducts`, `WheelTicketProducts`), receipt validation via `ProcessReceipt`.
16. `TradeService` — sessions, reservation locks, history (`TradePublicFlags`,
    `TradeQuickChat`, `TradeHistory_Request`), RAP-based value display, anti-scam confirms.
17. `BoothService` (player shops), `DailyRewards`, `RedeemCode`, `CurrencyGiftRequest`.

### Phase 3 — progression and social
18. `BattlePass` (89 KB controller exists) + `SeasonPass` (catalog + gates + rewards).
19. `TaskService` — daily / special / beginner tasks (`DailyTasks_*`, `SpecialTasks_*`,
    `BeginnerTask_*` remotes already defined).
20. `ClanService` — create/join/leave, clan tag display, clan leaderboard, reward periods,
    `clanrewards` admin command.
21. `LeaderboardService` — kills, wins, level, win streak, Robux spent, clans
    (six surface boards in the lobby, all with recovered controllers).
22. `MatchHistory` + `WinScreen` cutscene + `WinStreak` restore.

### Phase 4 — platform
23. `MatchmakingService` — modes, queue state, warmup, rematch vote, auto-requeue, parties
    (`PartySystem`, `PartyView`, `InvitePickerUI` all recovered).
24. `PlazaService` — server list, teleport tokens, plaza join (`PlazaServerList`,
    `PlazaTeleportModal`, `PlazaTeleportChoice`).
25. `ReplayService` — record authoritative frames server-side, encode with the existing
    `ReplayFormat`/`ReplayCodec`, ship via `ReplayData`, playback through `ReplayPuppets`.
26. `EventService` — Halloween wheel, UFO event, plague/July/Korblox events, train events,
    collectible bubble spawner (`UFOEventTimeline`, `EventTimer` recovered).
27. `AnalyticsService` — funnel events the client already fires (`ShopOpenAnalytics`,
    `PerfStats`, `InputCohortSync`, `ReportDevice`).

### Phase 5 — content
28. Emotes: catalog + wheel + shop + assign (`EmoteCatalog`, `EmoteProps`, `EmoteWheelController`).
29. Cosmetics: pack variants and colours (`PackCatalog` 20 KB, `PackVariants`,
    `PaintbrushColors`), knife/revolver skins, animated skins, held variants.
30. Finish the 26 GUI roots (they are already built — just bind to real data).
31. Mobile/console support (`MobileTouchController` 47 KB, `ControlLayout`, `KeybindSettings`).

### Phase 6 — ops, admin, hardening
32. `CmdrServerCommands` — only 14 server commands survived; the 260 client commands expect a
    server counterpart each (kick, kill, teleport, grant, crate, note, ban, event controls).
33. Real anti-cheat: server-authoritative movement/hit/currency, remote flood protection,
    `WeaponAuthConfig` enforcement, `ReportPlayer` pipeline, suspicious-hit logging.
34. Debug tooling gated to Studio/allowlist (`DebugCommandsClientFilter` exists client-side).

## 5. Security findings in the dump

- No hardcoded API keys, webhooks, or `require(assetId)` backdoors inside the place itself.
- `loadstring` appears exactly once, and it is legitimate: `Shared.ReplayFormatTest` compiles
  `ReplayFormat.Source` to self-test the codec.
- 46 modules touch `_G`/`rawget` — all are legit local caches/effect pools, not remote code loading.
- `HttpService` references (27 files) are type references and admin `fetch` utilities; no URLs.
- **Separate file `re.lua`** is *not* part of the place: it is a third-party cheat hub
  (fly/noclip/speed, player trolls, catalog emotes) and it contains a **hardcoded OpenRouter API
  key** in plaintext. If that key is yours, rotate it now — anyone with that script can spend it.
  Nothing in the dump depends on `re.lua`.

## 6. Legal / practical reality check

The dump is a rip of someone else's live game: the client code, UI, catalogs and art IDs are
Murder Duels' copyrighted work, captured with an exploit tool. Rebuilding the *server* from the
recovered API is straightforward engineering; shipping the recovered client plus copied assets
as your own game is a DMCA/ToS problem and Roblox will act on it. The clean path is to build
the server, then **replace recovered client code/assets with your own** as you go — or use this
as a reference implementation while writing a game of your own.

---

## Suggested order of work

Phase 0 → Phase 1 (round loop, roles, knife/gun, hits) gets you a playable match.
Phase 2 (profiles, cases, inventory) makes it sticky. Everything after is content widening.
Say the word and I will start writing Phase 0 + the `RemoteSchema` against the real remote list.
