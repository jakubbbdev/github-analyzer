![CI](https://github.com/jakubbbdev/github-analyzer/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/github/license/jakubbbdev/github-analyzer)
![Docker Pulls](https://img.shields.io/docker/pulls/jakubbbdev/github-analyzer)
![Release](https://img.shields.io/github/v/release/jakubbbdev/github-analyzer)

# Crystal GitHub Analyzer

A modern CLI tool written in [Crystal](https://crystal-lang.org/) to analyze GitHub profiles and display key stats in a stylish, colored terminal output.

## Features
- Colored ASCII logo and clean terminal output
- Shows name, followers, public repos, top 3 languages
- Top N repos by stars (with language and link, configurable)
- Total stars, forks, and most used license
- ASCII bar chart for repo activity per year
- Markdown export (`--markdown`)
- Help option (`--help`)
- Docker support (prebuilt image available)
- CI with GitHub Actions ![CI](https://github.com/jakubbbdev/github-analyzer/actions/workflows/ci.yml/badge.svg)

## Quick Start

### With Docker (recommended)
Pull and run directly:
```sh
docker pull jakubbbdev/github-analyzer
# Analyze a user:
docker run --rm jakubbbdev/github-analyzer <github-username>
# Example:
docker run --rm jakubbbdev/github-analyzer jakubbbdev
```

### Local (Crystal required)
```sh
git clone https://github.com/jakubbbdev/github-analyzer.git
cd github-analyzer
shards install
crystal run src/github_analyzer.cr -- <github-username>
```

## CLI Options
| Option         | Description                                 |
|---------------|---------------------------------------------|
| --help        | Show help text                              |
| --markdown    | Export analysis as Markdown file            |
| --top N       | Show top N repos (default: 3)               |
| --no-color    | Disable colored output                      |

## Markdown Export
Generate a Markdown report:
```sh
docker run --rm jakubbbdev/github-analyzer --markdown <github-username>
```
Creates a file: `github_<username>_analyse.md`

## Contributing
Contributions, issues and feature requests are welcome! Feel free to open a PR or issue.


## License
MIT 

BY JAKUBBBDEV