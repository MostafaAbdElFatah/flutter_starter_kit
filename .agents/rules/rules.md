---
trigger: always_on
---

# Project Rules

## 1. Global Rules
- The project shall remain maintainable, scalable, and feature-oriented at all times.
- Every change shall preserve clear separation of concerns between UI, state, domain logic, and data access.
- Code shall be production-ready; temporary hacks, placeholder logic, and silent fallbacks are not allowed in merged code.
- Each file shall have one clear responsibility. If a file starts serving multiple concerns, it shall be split.
- Reuse existing abstractions, components, mappers, and utilities before adding new implementations.
- All new code shall follow the established repository structure, dependency injection setup, routing approach, and state-management patterns already used in the project.
- Side effects shall be explicit, isolated, and easy to trace.
- Shared behavior shall live in `core/` or a dedicated reusable package only when it is truly cross-feature.
- Static assets, localization keys, and route names shall be centralized; they must not be duplicated across features.
- Public APIs inside the codebase shall be stable, predictable, and documented by naming and structure.

## 2. Flutter Rules
- Widgets shall focus on rendering and user interaction only; business rules and orchestration shall not live in widgets.
- Screens shall compose smaller widgets instead of accumulating large `build` methods.
- `build` methods shall stay pure and free from network calls, storage access, and direct dependency resolution.
- Expensive work shall be performed outside the widget tree and triggered through Cubits, Blocs, or injected services.
- Rebuild scope shall be kept narrow using appropriate widget extraction and `BlocBuilder`/`BlocSelector` placement.
- Reusable UI elements shall be placed in `core/components/` or feature-local widget folders based on scope of reuse.
- Theme, spacing, text styles, colors, and icons shall come from centralized project resources instead of inline duplication.
- Navigation shall go through the project routing system and named route definitions; direct ad hoc navigation patterns are not allowed.
- Localization shall use the project localization system and keys; user-facing strings shall not be hardcoded unless there is a deliberate technical exception.
- Platform-specific behavior, permissions, notifications, and device services shall be isolated in utilities or services, not embedded in UI widgets.
- Flutter performance rules shall be enforced: avoid unnecessary rebuilds, avoid large widget classes, avoid synchronous heavy work on the main isolate, and prefer lazy loading/pagination for large lists.
- UI behavior shall remain consistent across light/dark mode, localization direction, and responsive layouts already supported by the project.

## 3. Architecture Rules
- The project shall follow Clean Architecture with feature-first organization.
- `presentation/` is responsible for screens, widgets, Cubits/Blocs, view models, and UI mapping only.
- `domain/` is responsible for entities, repository contracts, and use cases only.
- `data/` is responsible for models, mappers, data sources, caching, endpoint definitions, and repository implementations only.
- Dependency direction shall always be inward: presentation -> domain, data -> domain, and never domain -> data or domain -> presentation.
- Repository interfaces shall be defined in the domain layer; repository implementations shall live in the data layer.
- Use cases shall encapsulate a single business action and shall be the primary entry point from presentation into domain logic.
- Data sources shall not be accessed directly from presentation or domain.
- DTOs/models shall not leak into domain or presentation; conversion to domain entities shall happen inside the data layer.
- API endpoint construction, request serialization, and response parsing shall remain in the data/infrastructure layer.
- Caching decisions shall be handled by repositories and data sources, not by widgets or Cubits/Blocs.
- Cross-feature dependencies shall be minimized. When a feature needs another feature's domain concept, depend on the smallest stable contract possible.
- `core/infrastructure/` shall contain shared technical foundations such as networking, storage, failures, pagination, and base abstractions.
- Dependency injection shall be registered through `injectable`/`get_it`; manual object graph construction inside features is not allowed except for framework-owned objects with clear lifecycle reasons.
- Local packages such as `share_hadith` and `html_selectable_text` shall remain modular and reusable; app-specific business rules shall not be pushed into them unless they are intentionally package-owned.

## 4. State Management Rules
- `Cubit` or `Bloc` shall be the only source of mutable UI state for non-trivial screens.
- Widgets shall read state and dispatch intents; they shall not compute business outcomes, manage persistence, or call repositories directly.
- Each Cubit/Bloc shall manage one coherent slice of state.
- States shall be explicit, immutable in practice, and represent UI-relevant conditions such as initial, loading, loaded, empty, and error when applicable.
- State classes shall be small, predictable, and comparable using the project’s existing equality conventions.
- State transitions shall happen only inside Cubits/Blocs.
- Async operations shall be triggered from Cubits/Blocs through use cases and handled with clear loading and error flows.
- Cancelation, debounce, pagination, and concurrency rules shall follow existing base abstractions such as `BaseCubit`, `BaseBloc`, and `OperationRunner`.
- UI-specific mapping from domain entities to display models shall happen in presentation mappers or Cubits/Blocs, not in widgets.
- Global state shall be reserved for truly global concerns only. Feature state shall remain inside the owning feature.
- A Cubit/Bloc shall not access another feature’s repository directly; cross-feature coordination shall go through use cases, routing, or stable shared abstractions.
- Emitted errors shall be user-safe and derived from the project failure-handling strategy rather than raw infrastructure details whenever possible.

## 5. AI Behavior Rules
- AI-generated changes shall follow the existing project architecture exactly.
- AI shall never bypass the domain layer, repository contracts, or established state-management flow to make a change faster.
- AI shall not place business logic in widgets, route builders, utility extensions, or ad hoc helpers when a use case or repository is required.
- AI shall reuse existing folders, naming patterns, base classes, and infrastructure before introducing new abstractions.
- AI shall not invent features, endpoints, models, states, or dependencies that are not required by the task.
- AI shall prefer conservative, consistent solutions over clever shortcuts.
- AI shall preserve dependency direction and separation of layers in every edit.
- AI shall keep code production-ready, typed, testable, and aligned with the repository’s current conventions.
- AI shall not duplicate logic that already exists elsewhere in the project; it shall extract or reuse instead.
- AI shall respect local package boundaries and shall not move app-specific concerns into shared packages without clear architectural intent.
- AI shall keep comments concise and useful; comments shall explain intent or non-obvious behavior, not restate code line by line.
- If the correct placement of logic is uncertain, AI shall choose the safest option that maintains architecture integrity and existing patterns.

## 6. Coding Standards
- Classes, enums, typedefs, and extensions shall use PascalCase.
- Variables, parameters, properties, methods, and functions shall use camelCase.
- Files and folders shall use snake_case.
- Feature folders shall remain consistent: `data/`, `domain/`, and `presentation/` shall not be skipped when the feature complexity requires layered separation.
- SOLID principles shall be applied, especially single responsibility, dependency inversion, and interface-based boundaries.
- Functions shall stay small, purposeful, and readable.
- Methods shall do one thing and shall be named by intent, not by implementation detail.
- Duplicated logic shall be extracted to the appropriate layer instead of copied.
- Domain entities shall remain framework-agnostic and free from Flutter-specific dependencies.
- Exceptions and failures shall be normalized through the project error-handling abstractions; raw exceptions shall not propagate unpredictably across layers.
- Nullability shall be explicit and intentional; avoid nullable design when a non-null invariant is possible.
- Imports shall be clean and minimal; unused dependencies and dead code are not allowed.
- Generated files shall not be edited manually unless regeneration is impossible and the change is explicitly justified.
- Tests shall be added or updated for meaningful logic changes in use cases, repositories, data sources, validators, and other non-trivial units.
- Comments shall explain intent, invariants, or edge cases only; redundant comments are not allowed.

## 7. Git & Workflow Rules
- Branches shall use structured naming: `feature/*`, `fix/*`, or `chore/*`.
- Every branch shall address one focused unit of work.
- Commits shall be small, atomic, and reversible.
- Commit messages shall be clear, action-oriented, and scoped to the change.
- Pull Requests shall be required for all non-trivial changes.
- No code shall be merged without review.
- Review feedback shall be resolved in code, not ignored in discussion.
- Before merge, the author shall ensure the change builds, passes relevant tests, and does not break analyzer expectations.
- Refactors and feature work shall not be mixed with unrelated formatting or cleanup changes in the same PR.
- Generated files shall be included in a PR only when the corresponding source change requires them.
- Direct commits to protected mainline branches are not allowed.
