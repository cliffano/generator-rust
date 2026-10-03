//! Command-line argument parsing and dispatch.

use std::path::PathBuf;

use clap::{Parser, Subcommand};

use crate::display::Display;

#[derive(Parser)]
#[command(name = "{{project_id}}", about = "{{project_desc}}", version)]
pub struct Cli {
    /// Configuration file
    #[arg(short = 'c', long = "config-file", default_value = "{{project_id}}.yaml")]
    config_file: PathBuf,

    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Display message
    Display {
        /// When reverse is enabled, message text is written in reverse, default: false
        #[arg(short = 'r', long = "reverse", default_value_t = false, action = clap::ArgAction::Set)]
        reverse: bool,

        /// Message text transformation type, can be lower or upper, default: lower
        #[arg(short = 't', long = "transform", default_value = "lower")]
        transform: String,
    },
}

pub fn run() -> std::io::Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Commands::Display { reverse, transform } => {
            let display = Display::new(&cli.config_file)?;
            let text = display.format(reverse, &transform);
            println!("Message: {text}");
        }
    }

    Ok(())
}
