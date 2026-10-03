//! Run with: cargo run --example display

use {{snakecase project_id}}::display::Display;

fn main() {
    let display = Display::new("examples/{{project_id}}.yaml").expect("failed to load config");
    let text = display.format(false, "lower");
    println!("{text}");
}
