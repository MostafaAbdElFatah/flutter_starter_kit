# AGENTS.md — AI Coding Assistant Rules for This Project

## Rule Source of Truth
- `AGENTS.md` is the canonical Codex instruction file for this repository.
- Variant rule files live under `.agents/rules/` for reference and prompt-size-specific reuse.
- If any rule in `.agents/rules/` differs from `AGENTS.md`, follow `AGENTS.md`.
- When rules are updated, keep `.agents/rules/` aligned with this file.

## Project Overview
This is a Flutter project following Clean Architecture. It uses presentation, domain, and data layers. State management is done with Cubit/Bloc. Dependency injection uses get_it/injectable. All code must be maintainable, scalable, and production-ready.

## 1. Global Rules
- Maintain clear separation of UI, state, domain logic, and data access.
- One file = one responsibility; split when multiple concerns arise.
- Reuse existing abstractions, components, mappers, and utilities.
- Static assets, localization keys, and route names must be centralized.
- Public APIs inside the codebase shall be stable and predictable.

## 2. Flutter Rules
- Widgets only handle rendering and interaction.
- Business logic must live in Cubits/Blocs, use cases, or repositories.
- `build` methods must be pure; no network/storage calls.
- Rebuild scope must be narrow using proper selectors.
- Navigation must use the project routing system.
- Localization keys must be used; no hardcoded UI strings.

## 3. Architecture Rules
- Follow Clean Architecture strictly: presentation -> domain -> data.
- Repositories are defined in domain and implemented in data.
- DTOs/models must not leak into domain/presentation.
- Use cases encapsulate one business action each.
- Data sources are only accessed by repositories.

## 4. State Management Rules
- Only Cubit/Bloc manages mutable UI state.
- Widgets dispatch intents and read state; no business logic.
- Async operations triggered from Cubits/Blocs via use cases.
- States represent UI conditions (loading, loaded, error, etc.).
- Cross-feature repository access is not allowed directly.

## 5. AI Behavior Rules
- AI must not bypass domain layer or established flows.
- AI must reuse existing patterns and follow naming conventions.
- AI must not invent features, endpoints, or dependencies.
- AI must preserve dependency direction and separation of layers.
- If uncertain, AI must ask for clarification.

## 6. Coding Standards
- PascalCase for classes, enums; camelCase for variables, methods.
- snake_case for files and folders.
- Nullability must be explicit and intentional.
- Generated files must not be edited manually.

## 7. Testing Rules
- Unit tests for use cases, repositories, data sources.
- UI tests for critical screens.
- Mocks/fakes must be used for external dependencies.

## 8. Error Handling Rules
- Failures must be mapped to domain failures.
- Raw exceptions must not reach UI.
- UI must display user-safe messages only.

## 9. DI Rules
- Use get_it + injectable for DI.
- No manual object graph construction except for framework cases.

## 10. Git & Workflow
- Branch naming: feature/*, fix/*, chore/*.
- PRs required for all non-trivial changes.
- Commits must be small, atomic, and reversible.

## 11. Performance & Scalability
- Avoid unnecessary rebuilds.
- Use lazy loading/pagination for large lists.
- Heavy work must be outside UI.

## Build & Test Commands
run: flutter pub get
run: flutter analyze
run: flutter test
run: flutter build

## How AI Should Behave
- Always follow these rules.
- Ask for clarification when requirements are ambiguous.
- Produce small, reviewable diffs.
- Ensure generated code compiles, passes tests, and matches project style.
