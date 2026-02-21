## 1.0.3
## 1.0.2

- Lazy mode supported

## 1.0.1
## 1.0.0

- Singleton manager for app-wide settings.
- Supports **primitive types**: `int`, `double`, `String`, `bool`, `null`.
- Supports **collections**: `List<int>`, `List<double>`, `List<String>`, `List<bool>`.
- Supports **maps and JSON** with nested structures.
- Automatic **DataType detection** for stored values.
- Optional **custom storage delegate** for local or remote persistence.
- Operations:
    - `get` — retrieve a value with type safety.
    - `set` — store a value.
    - `increment` — increment numeric values.
    - `arrayUnion` — add elements to a list without duplicates.
    - `arrayRemove` — remove elements from a list.
- Handles **empty lists and maps** gracefully.
- Built-in **logging support** for debugging.
- Deep string parsing for numeric and boolean detection.

