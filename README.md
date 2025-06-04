# ReadlyIt

ReadlyIt is a minimal **Read It Later** application built with Flutter.
It supports Android, iOS, macOS, Linux and Windows platforms.

## Features

* Import links from the system share menu using **receive_sharing_intent**.
* Import Pocket export files (`.html`) through the app bar action.
* Riverpod based state management with Hive persistence and optional iCloud sync.
* Multi language user interface (English, 中文 and 日本語).
* Appearance settings with light/dark mode toggle, font size and default reading mode.
* Built in web view with toggleable reading mode.
* Modern Material 3 UI with card-based reading list.
* Modular storage layer with in-memory implementation for unit tests.

This project is only a basic demo and can be extended with more
functionality such as background sync or advanced parsing.

## Testing

Run unit tests with:

```bash
flutter test
```

The project includes model and provider tests using an in-memory
storage service for fast execution.
