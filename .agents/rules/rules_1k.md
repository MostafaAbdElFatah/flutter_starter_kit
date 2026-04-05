---
trigger: always_on
---

# Rules 1K

- Flutter + Clean Architecture project.
- Follow layer order strictly: presentation -> domain -> data.
- Widgets only render UI and dispatch intents.
- Put business logic in Cubit/Bloc, use cases, and repositories.
- Never call data sources from presentation.
- Reuse existing patterns, DI, mappers, routes, assets, and localization keys.
- Keep `build` methods pure and rebuild scope narrow.
- Cubit/Bloc is the only owner of mutable UI state.
- States must clearly represent loading/loaded/error/empty conditions.
- Repository contracts live in domain; implementations live in data.
- Models/DTOs must not leak outside data.
- Map raw exceptions to project failures; UI shows safe messages only.
- Use `get_it` + `injectable` for DI.
- Naming: PascalCase classes, camelCase members, snake_case files.
- Do not edit generated files manually.
- Add/update tests for changed logic and use mocks/fakes for external deps.
- Workflow: `feature/*`, `fix/*`, `chore/*`, small commits, PR for non-trivial changes.
- AI must not invent features, dependencies, or shortcuts.
- If requirements are unclear, ask before coding.
- Validate with: `flutter pub get`, `flutter analyze`, `flutter test`, `flutter build`.
