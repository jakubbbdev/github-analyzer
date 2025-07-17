# Crystal GitHub Analyzer

A modern CLI tool written in [Crystal](https://crystal-lang.org/) to analyze GitHub profiles and display key stats in a stylish, colored terminal output.

## Features
- Colored ASCII logo and clean terminal output
- Shows name, followers, public repos, top 3 languages
- Top 3 repos by stars (with language and link)
- ASCII bar chart for repo activity per year
- Markdown export (`--markdown`)
- Help option (`--help`)
- Docker support (prebuilt image available)

## Quick Start

### With Docker (recommended)
```sh
docker run --rm jakubbbdev/github-analyzer <github-username>
```
Example:
```sh
docker run --rm jakubbbdev/github-analyzer jakubbbdev
```

### Local (Crystal required)
```sh
git clone https://github.com/jakubbbdev/github-analyzer.git
cd github-analyzer
shards install
crystal run src/github_analyzer.cr -- <github-username>
```

## Example Output
```
   ____ _ _   _     _     _     _                 _
  / ___(_) |_| |__ (_)___| |__ (_)_ __ ___   __ _| |_ ___  _ __
 | |  _| | __| '_ | / __| '_ | | '_ ` _  / _` | __/ _ | '__|
 | |_| | | |_| | | | __  | | | | | | | | | (_| | || (_) | |
  ____|_|__|_| |_|_|___/_| |_|_| |_| |_|__,_|_____/|_|
─────────────────────────────────────────────────────────────────
Analyzing GitHub profile: jakubbbdev...
─────────────────────────────────────────────────────────────────

Name: jakubbbdev
Public Repos: 7
Followers: 0
Following: 0
Profile: https://github.com/jakubbbdev

Top 3 Languages:
  1. Shell
  2. Java
  3. Rust

Top 3 Repos by Stars:
  1. configs (Shell) ★0 - https://github.com/jakubbbdev/configs
  2. flow (Rust) ★0 - https://github.com/jakubbbdev/flow
  3. github-analyzer (Crystal) ★0 - https://github.com/jakubbbdev/github-analyzer

Activity per Year:
  2025:  7 ██████████████████████████████

═════════════════════════════════════════════════════════════════
Done!
```

## Markdown Export
Generate a Markdown report:
```sh
docker run --rm jakubbbdev/github-analyzer --markdown <github-username>
```
Creates a file: `github_<username>_analyse.md`

## License
MIT 