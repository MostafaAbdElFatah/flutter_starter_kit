---
trigger: always_on
---

# Rules 4K

## Project Context
- Flutter app using Clean Architecture.
- Layers: `presentation`, `domain`, `data`.
- State: Cubit/Bloc.
- DI: `get_it` + `injectable`.

## Required Rules
- Keep UI, state, domain logic, and data access separated.
- Reuse existing abstractions, widgets, mappers, and utilities.
- Keep files focused on one responsibility.
- Centralize localization keys, routes, and assets.

## Flutter
- Widgets render and dispatch actions only.
- No business logic, storage access, or network calls in widgets.
- `build` methods must be pure.
- Keep rebuild scope narrow.
- Use project routing and localization systems.

## Architecture
- Follow presentation -> domain -> data strictly.
- Presentation uses use cases and state objects only.
- Domain owns entities, repository contracts, and business actions.
- Data owns repository implementations, data sources, models, and mapping.
- Models/DTOs must not leak out of the data layer.
- Data sources are accessed only by repositories.

## State Management
- Cubit/Bloc owns mutable screen state.
- Widgets read state and send intents only.
- Async work starts in Cubit/Bloc and goes through use cases.
- States must reflect UI conditions clearly.
- Do not access other features' repositories directly from UI/state layers.

## Error Handling
- Map raw exceptions into project failures.
- Do not expose infrastructure errors directly to UI.
- Show only user-safe messages in screens.

## DI
- Use `get_it` and `injectable`.
- Avoid manual object graph construction unless framework lifecycle requires it.

## Coding Standards
- PascalCase: classes/enums.
- camelCase: methods/variables.
- snake_case: files/folders.
- Keep functions small, readable, and focused.
- Nullability must be explicit.
- Do not edit generated files manually.

## Testing
- Add/update unit tests for changed business logic.
- Use mocks/fakes for external dependencies.
- Cover critical UI flows when behavior changes materially.

## Workflow
- Branches: `feature/*`, `fix/*`, `chore/*`.
- Small atomic commits.
- PRs for non-trivial changes.

## AI Behavior
- Follow `AGENTS.md` first.
- Reuse project patterns.
- Do not invent new architecture or shortcuts.
- Ask for clarification if the task is ambiguous.
- Ensure code is production-ready and consistent with project style.

## Commands
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build`
