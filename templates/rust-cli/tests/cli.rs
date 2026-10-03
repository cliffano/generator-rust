use assert_cmd::Command;
use predicates::prelude::*;

#[test]
fn display_shows_help() {
    Command::cargo_bin("{{project_id}}")
        .unwrap()
        .arg("--help")
        .assert()
        .success()
        .stdout(predicate::str::contains("Usage"));
}

#[test]
fn display_command_with_default_config() {
    Command::cargo_bin("{{project_id}}")
        .unwrap()
        .args(["--config-file", "examples/{{project_id}}.yaml", "display"])
        .assert()
        .success()
        .stdout(predicate::str::contains("Message: hello world"));
}

#[test]
fn display_command_with_reverse_and_upper() {
    Command::cargo_bin("{{project_id}}")
        .unwrap()
        .args([
            "--config-file",
            "examples/{{project_id}}.yaml",
            "display",
            "--reverse",
            "true",
            "--transform",
            "upper",
        ])
        .assert()
        .success()
        .stdout(predicate::str::contains("Message: DLROW OLLEH"));
}
