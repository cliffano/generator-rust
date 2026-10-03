//! The Message model: holds text and applies simple transformations.

pub struct Message {
    text: String,
}

impl Message {
    pub fn new(text: impl Into<String>) -> Self {
        Message { text: text.into() }
    }

    pub fn text(&self) -> &str {
        &self.text
    }

    pub fn reverse(&mut self) {
        self.text = self.text.chars().rev().collect();
    }

    pub fn to_lower(&mut self) {
        self.text = self.text.to_lowercase();
    }

    pub fn to_upper(&mut self) {
        self.text = self.text.to_uppercase();
    }
}

impl std::fmt::Display for Message {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.text)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn reverse_reverses_text() {
        let mut message = Message::new("Hello World");
        message.reverse();
        assert_eq!(message.text(), "dlroW olleH");
    }

    #[test]
    fn to_lower_lowercases_text() {
        let mut message = Message::new("Hello World");
        message.to_lower();
        assert_eq!(message.text(), "hello world");
    }

    #[test]
    fn to_upper_uppercases_text() {
        let mut message = Message::new("Hello World");
        message.to_upper();
        assert_eq!(message.text(), "HELLO WORLD");
    }
}
