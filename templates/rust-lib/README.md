<!-- BEGIN:AVATAR -->
To be populated by generator-rust rust-lib-partials
<!-- END:AVATAR -->

<!-- BEGIN:BADGES -->
To be populated by generator-rust rust-lib-partials
<!-- END:BADGES -->

# {{project_name}}

{{project_name}} is a {{project_desc}} .

## Installation

```bash
cargo add {{project_id}}
```

## Usage

Create a configuration file, e.g. `{{project_id}}.yaml`:

```yaml
---
text: Hello World
```

Create a `Display` and format its message:

```rust
use {{snakecase project_id}}::display::Display;

let display = Display::new("{{project_id}}.yaml").unwrap();
let text = display.format(false, "lower");
println!("{text}");
```

## Configuration

These are the configuration properties that you can use with `{{project_id}}`.
Some example configuration files are available on [examples](examples) folder.

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `text` | String | The message text | Hello World |

## Colophon

<!-- BEGIN:DEVELOPERS_GUIDE -->
To be populated by generator-rust rust-lib-partials
<!-- END:DEVELOPERS_GUIDE -->

<!-- BEGIN:BUILD_REPORTS -->
To be populated by generator-rust rust-lib-partials
<!-- END:BUILD_REPORTS -->
