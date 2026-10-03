//! Loads a YAML configuration file and formats its message text.

use std::fs;
use std::path::Path;

use serde::Deserialize;

use crate::message::Message;

#[derive(Debug, Deserialize)]
struct Config {
    text: String,
}

pub struct Display {
    conf: Config,
}

impl Display {
    pub fn new(conf_file: impl AsRef<Path>) -> std::io::Result<Self> {
        let content = fs::read_to_string(conf_file)?;
        let conf: Config = serde_yaml::from_str(&content)
            .map_err(|e| std::io::Error::new(std::io::ErrorKind::InvalidData, e))?;
        Ok(Display { conf })
    }

    pub fn format(&self, reverse: bool, transform: &str) -> String {
        let mut message = Message::new(self.conf.text.clone());

        if reverse {
            message.reverse();
        }

        match transform {
            "upper" => message.to_upper(),
            _ => message.to_lower(),
        }

        message.text().to_string()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn fixture_path() -> String {
        concat!(env!("CARGO_MANIFEST_DIR"), "/examples/{{project_id}}.yaml").to_string()
    }

    #[test]
    fn format_lowercases_by_default() {
        let display = Display::new(fixture_path()).unwrap();
        assert_eq!(display.format(false, "lower"), "hello world");
    }

    #[test]
    fn format_reverses_and_uppercases() {
        let display = Display::new(fixture_path()).unwrap();
        assert_eq!(display.format(true, "upper"), "DLROW OLLEH");
    }
}
