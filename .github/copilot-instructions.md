# Project Guidelines

## Build and Test

- Run `flutter pub get` before builds or tests when dependencies may be stale.
- Use `flutter analyze` for static analysis.
- Use `flutter test` for the full test suite.
- Use `flutter test test/viewmodels/calculadora_controller_test.dart` or `flutter test test/domain/usecases/calcular_elegibilidade_pec14_usecase_test.dart` when changing calculator logic.
- Use `flutter run` for local debugging.
- For release packaging on Windows, use `build_all.bat` from the repo root.
- For release packaging on Linux or macOS, use `build_all.sh` from the repo root.
- Release artifact renaming and copying is handled by `rename_builds.dart`; do not rename files manually unless the script is being updated.

## Architecture

- This is a Flutter app with a hybrid structure under `lib/`.
- `lib/main.dart` wires a `MaterialApp` with Portuguese-only locale support and named routes for home, quiz, and calculator flows.
- `lib/viewmodels/`, `lib/views/`, and `lib/widgets/` contain the main calculator app flow using `ChangeNotifier` controllers and direct widget composition.
- `lib/domain/` contains shared domain enums and use cases for business rules.
- `lib/quiz/` is more modular than the rest of the app: use its `data/`, `domain/`, and `presentation/` split as the local pattern when working inside the quiz feature.
- `lib/design_system/` contains theme tokens and shared UI styling.

## Conventions

- Preserve the existing Portuguese product language and user-facing copy unless the task explicitly requires changing it.
- Prefer the existing `ChangeNotifier`-based controller pattern over introducing new state-management libraries.
- Keep changes minimal and consistent with the current hybrid structure instead of trying to force a full architectural rewrite.
- Business-rule changes for retirement eligibility should be validated with focused tests in `test/domain/usecases/` and `test/viewmodels/`.
- The analyzer inherits `package:flutter_lints/flutter.yaml`; `avoid_print` is intentionally disabled for scripts and build utilities.
- Versioning comes from `pubspec.yaml` using `X.Y.Z+build`; release scripts and `rename_builds.dart` depend on that format.

## Project Notes

- The app currently supports only `pt_BR` locale in `lib/main.dart`; do not assume generic i18n infrastructure exists.
- `build_all.bat` builds Android, Windows, and Web artifacts on Windows. `build_all.sh` builds Android plus platform-conditional targets on Linux or macOS.
- Icon generation is configured through `flutter_launcher_icons` in `pubspec.yaml`. Follow `ICON_SETUP.md` when updating app icons.
- CI currently covers Android release builds in `.github/workflows/build_app.yml`.

## References

- See `ICON_SETUP.md` for icon generation steps and platform naming notes.
- See `.github/workflows/build_app.yml` for the current CI release flow.
- See `.github/prompts/plan-reorganizeCalculadoraLayout.prompt.md` for an example of task-specific prompt customization already used in this repo.