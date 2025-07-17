# Crystal GitHub Analyzer

Ein stylisches CLI-Tool in [Crystal](https://crystal-lang.org/), das GitHub-Profile analysiert und die wichtigsten Infos farbig und als ASCII-Grafik im Terminal ausgibt.

## Features
- Farbiges ASCII-Logo und stylische Terminal-Ausgabe
- Zeigt Name, Follower, Repo-Anzahl, Top-3-Sprachen
- Top 3 Repos nach Stars (mit Sprache und Link)
- ASCII-Balkendiagramm für die Repo-Aktivität pro Jahr
- Export als Markdown-Datei (`--markdown`)
- Hilfetext (`--help`)

## Beispiel-Ausgabe
```text
   ____ _ _   _     _     _     _                 _             
  / ___(_) |_| |__ (_)___| |__ (_)_ __ ___   __ _| |_ ___  _ __ 
 | |  _| | __| '_ \| / __| '_ \| | '_ ` _ \ / _` | __/ _ \| '__|
 | |_| | | |_| | | | \__ \ | | | | | | | | | (_| | || (_) | |   
  \____|_|\__|_| |_|_|___/_| |_|_| |_| |_|[35m\__,_|[0m\u001b[36m\__\___/|_|   
─────────────────────────────────────────────────────────────────
Analysiere GitHub-Profil von octocat...
─────────────────────────────────────────────────────────────────

Name: octocat
Public Repos: 8
Follower: 5000
Folgt: 9
Profil: https://github.com/octocat

Top 3 Sprachen:
  1. Ruby
  2. JavaScript
  3. Shell

Top 3 Repos nach Stars:
  1. Spoon-Knife (HTML) ★10000 - https://github.com/octocat/Spoon-Knife
  2. Hello-World (Ruby) ★9000 - https://github.com/octocat/Hello-World
  3. octocat.github.io (JavaScript) ★8000 - https://github.com/octocat/octocat.github.io

Aktivitätsübersicht (Repos pro Jahr):
  2019:  2 ████████
  2020:  3 █████████████
  2021:  1 ████
  2022:  2 ████████

═════════════════════════════════════════════════════════════════
Fertig!
```

## Installation
1. [Crystal installieren](https://crystal-lang.org/install/)
2. Im Projektordner:
   ```sh
   shards install
   crystal run src/github_analyzer.cr -- --help
   ```

## Nutzung
```sh
crystal run src/github_analyzer.cr -- <github-username>
crystal run src/github_analyzer.cr -- --markdown <github-username>
```

## Markdown-Export
Mit `--markdown` wird eine Datei `github_<username>_analyse.md` erzeugt, die du direkt in dein GitHub-Profil einbinden kannst.

## Lizenz
MIT

---
Viel Spaß beim Ausprobieren! Starte gern einen PR oder Issue, wenn du Ideen hast 🚀 