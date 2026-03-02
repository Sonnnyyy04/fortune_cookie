# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter mobile application (Dart). Project name: `untitled`. Targets Android (and potentially iOS). Dart SDK constraint: `^3.10.4`.

## Common Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run the app
flutter test             # Run all tests
flutter test test/foo_test.dart  # Run a single test file
flutter analyze          # Static analysis / linting
flutter build apk        # Build Android APK
flutter build appbundle  # Build Android App Bundle
```

## Architecture

Fresh Flutter scaffold — no custom architecture pattern (BLoC, Provider, Riverpod, etc.) is established yet. Key directories:

- `lib/` — All application Dart source code
- `test/` — Flutter widget and unit tests
- `android/` — Native Android platform wrapper (Gradle)

## Linting

Uses `package:flutter_lints/flutter.yaml` as the base lint ruleset (configured in `analysis_options.yaml`).

## Task

Привет, мы пишем приложение на flutter. По этому пути C:\Users\eldorado\Desktop\Мобилки
лежит файл ТЗ.docx ознакомьзя с ним, там у меня вариант 7 Печенька с предсказаниями. В нем описаны требования для приложения. В конечном итоге должен получиться приложения, но так
эта работа складывается из лабораторных, то надо делать и сдавать мне преподавателю по лабораторным. Соответственно по этому пути также лежат файлы 1,2,3-5.docx это уже задания на сами лабы. В них в основном описано для котлин, но ты делай для flutter. То есть на выходе должен получиться рабочее приложение, а также 3 ветки по заданиям в гитхабе и 1 ветка main в котором будет лежать уже рабочее приложение. Сначала построй план