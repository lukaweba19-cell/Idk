# Chat + translation tests

The chat logic lives inside `re.txt` between the `CHAT_CORE_BEGIN` / `CHAT_CORE_END`
markers. `chat_core.test.luau` slices that block out, loads it with stubbed Roblox
globals (`game`, `Players`, `player`, `TextChatService`, `task`), a stubbed executor
`request` that records every HTTP call, and a stubbed `RBXGeneral` channel that
records every sent message.

Run it with [Lune](https://lune-org.github.io/docs):

```bash
lune run tests/chat_core.test.luau
```

It fails with a non-zero exit code if any check fails. Covered:

- `re.txt` still compiles as Luau.
- Receiving chat costs **0** OpenRouter requests and is never auto-translated.
- 🌐 on a message costs exactly **1** request (language + translation in one call);
  clicking it again only flips original/translation and costs 0.
- ↩️ reply + send costs exactly **1** request and goes out in the replied player's
  language; a send after that does not re-translate.
- The language selector: chosen language = 1 request, English = 0, cached repeats = 0.
- No double send: a second press while a send is in flight is refused.
- Language detection: 84 named languages, script + unique-letter + function-word
  matching, English never falsely tagged; sample phrases for 38 languages detected
  offline with 0 requests.
- No duplicate rows: own echo, filtered echo, duplicate listener delivery and the
  legacy + modern chat systems together all render one row per message.
