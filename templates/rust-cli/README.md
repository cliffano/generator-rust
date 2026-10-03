<!-- BEGIN:AVATAR -->
To be populated by generator-rust rust-cli-partials
<!-- END:AVATAR -->

<!-- BEGIN:BADGES -->
To be populated by generator-rust rust-cli-partials
<!-- END:BADGES -->

# {{project_name}}

{{project_name}} is a {{project_desc}} .

## Installation

```bash
cargo install {{project_id}}
```

## Usage

Create a configuration file, e.g. `{{project_id}}.yaml`:

```yaml
---
text: Hello World
```

Run {{project_id}} with display command:

```bash
{{project_id}} display
```

Run {{project_id}} with specified config file:

```bash
{{project_id}} --config-file {{project_id}}.yaml display
```

Run {{project_id}} with specified config file and custom flags:

```bash
{{project_id}} --config-file {{project_id}}.yaml display --reverse true --transform upper
```

Show help guide:

```bash
{{project_id}} --help
```

## Configuration

These are the configuration properties that you can use with `{{project_id}}` CLI.
Some example configuration files are available on [examples](examples) folder.

| Property | Type | Description | Example |
|----------|------|-------------|---------|
| `text` | String | The message text | Hello World |

## Colophon

<!-- BEGIN:DEVELOPERS_GUIDE -->
To be populated by generator-rust rust-cli-partials
<!-- END:DEVELOPERS_GUIDE -->

<!-- BEGIN:BUILD_REPORTS -->
To be populated by generator-rust rust-cli-partials
<!-- END:BUILD_REPORTS -->
