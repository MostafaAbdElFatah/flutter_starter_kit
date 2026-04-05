---
trigger: always_on
---

# Rules 10K

## Purpose
This version is the most complete repository guidance for AI agents and developers working in a larger prompt budget. It preserves the full operating model of the project and should be preferred when context size allows.

## Project Context
- Flutter application.
- Clean Architecture with feature-first structure.
- Layers: `presentation`, `domain`, `data`.
- State management: Cubit/Bloc.
- DI: `get_it` + `injectable`.
- Code quality target: maintainable, scalable, production-ready.

## Core Operating Principles
- Preserve separation of concerns between UI, state, business rules, and data access.
- Keep every file focused on one responsibility.
- Reuse existing abstractions before introducing new ones.
- Prefer predictable and reviewable changes over clever shortcuts.
- Keep public APIs and internal boundaries stable.
- Use centralized assets, localization keys, route names, and shared resources.

## Flutter Rules
- Widgets render state and dispatch user intents only.
- Widgets must not contain business rules, persistence logic, or direct network calls.
- `build` methods must stay pure.
- Rebuild scope must remain narrow through widget extraction and proper Bloc/Cubit selectors/builders.
- Use the project routing system for navigation.
- Use localization keys instead of hardcoded UI strings.
- Keep platform behavior, permissions, notifications, and device services outside the UI layer.
- Move heavy work out of the UI thread whenever possible.

## Architecture Rules

### Presentation
- Owns pages, screens, widgets, Cubits/Blocs, view states, and UI mappers.
- May depend on domain contracts and use cases.
- Must not depend on concrete data sources or DTOs/models.

### Domain
- Owns entities, repository contracts, and use cases.
- Contains business actions and app rules.
- Must stay framework-agnostic.
- Must not depend on presentation or data implementations.

### Data
- Owns repository implementations, remote/local data sources, DTOs/models, endpoint definitions, serialization, and caching.
- Converts external and persistence models into domain entities.
- Must fulfill domain repository contracts.

### Dependency Direction
- Presentation -> Domain.
- Data -> Domain.
- Domain must not depend on Data or Presentation.
- Data sources are accessed only through repositories.
- Use cases are the primary entry point from presentation to domain logic.

## State Management Rules
- Cubit/Bloc is the only owner of mutable screen state.
- Widgets read state and send intents; they do not coordinate business flows.
- Async work must be started in Cubits/Blocs and routed through use cases.
- States must represent real UI conditions such as initial, loading, success, empty, and error.
- State transitions must be explicit and predictable.
- Cross-feature repository access from presentation is not allowed.
- Shared or global state must be reserved for truly global concerns.
- Pagination, debouncing, cancelation, and concurrency should reuse existing project abstractions.

## Error Handling Rules
- Map low-level exceptions into project failures.
- Raw infrastructure exceptions must not leak to the UI.
- UI-facing messages must be safe and understandable.
- Error handling behavior must stay consistent across features.
- Remote, cache, and validation failures must be surfaced through established project patterns.

## DI Rules
- Register dependencies with `injectable` and resolve through `get_it`.
- Do not build ad hoc object graphs inside features.
- Manual construction is allowed only where framework lifecycle requires it.
- Prefer constructor injection for testability and explicit dependencies.

## Coding Standards
- Classes/enums/extensions: PascalCase.
- Variables/methods/properties/params: camelCase.
- Files/folders: snake_case.
- Keep functions small and focused.
- Prefer meaningful names over comments.
- Nullability must be explicit and intentional.
- Generated files must not be edited manually.
- Follow existing naming and folder conventions before adding new ones.
- Keep diffs small and cohesive.

## Testing Rules
- Add or update unit tests for use cases, repositories, and data sources when behavior changes.
- Add UI tests for critical user flows when the change affects them.
- Use mocks or fakes for external systems and side effects.
- Tests must validate business behavior, not implementation trivia.

## Performance & Scalability Rules
- Avoid unnecessary widget rebuilds.
- Use lazy loading or pagination for large datasets.
- Keep expensive work outside the widget tree.
- Prefer reusable and composable solutions that scale across features.
- Do not introduce patterns that make future extraction or testing harder.

## Git & Workflow Rules
- Branches: `feature/*`, `fix/*`, `chore/*`.
- Keep commits small, atomic, and reversible.
- Use pull requests for all non-trivial changes.
- Prefer small reviewable diffs.
- Ensure analyzer/tests/build expectations are satisfied before merge.

## AI Behavior Rules
- Read and follow `AGENTS.md` before generating code.
- Never bypass the domain layer or established project flows.
- Reuse existing patterns, DI, error handling, and test structure.
- Do not invent endpoints, dependencies, features, or architecture shortcuts.
- Ask for clarification when requirements are incomplete or ambiguous.
- Produce production-ready code that matches repository style.
- Verify compile/analyze/test paths when code changes require it.

## Build & Test Commands
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build`
