require "crest"
require "option_parser"

# ANSI-Farbcodes
module Color
  def self.code(name : Symbol) : String
    case name
    when :red; "\e[31m"
    when :green; "\e[32m"
    when :yellow; "\e[33m"
    when :blue; "\e[34m"
    when :magenta; "\e[35m"
    when :cyan; "\e[36m"
    when :light_green; "\e[92m"
    when :light_magenta; "\e[95m"
    else; ""
    end
  end
  def self.paint(text : String, color : Symbol) : String
    "#{code(color)}#{text}\e[0m"
  end
end

# Hilfsfunktion: Top 3 Sprachen aus Repo-Liste extrahieren
def top_languages(repos)
  langs = Hash(String, Int32).new(0)
  repos.each do |repo|
    lang = repo["language"]?.to_s
    langs[lang] += 1 unless lang.empty?
  end
  langs.to_a.sort_by { |(_, v)| -v }[0, 3].map(&.first)
end

# GitHub-Userdaten abfragen
def fetch_user(username : String)
  Crest.get("https://api.github.com/users/#{username}").body
end

def fetch_repos(username : String)
  Crest.get("https://api.github.com/users/#{username}/repos?per_page=100").body
end

# ASCII-Logo
logo = <<-LOGO
   ____ _ _   _     _     _     _                 _             
  / ___(_) |_| |__ (_)___| |__ (_)_ __ ___   __ _| |_ ___  _ __ 
 | |  _| | __| '_ \| / __| '_ \| | '_ ` _ \ / _` | __/ _ \| '__|
 | |_| | | |_| | | | \__ \ | | | | | | | | | (_| | || (_) | |   
  \____|_|\__|_| |_|_|___/_| |_|_| |_| |_|\__,_|\__\___/|_|   
LOGO

# ASCII-Logo prominent und farbig ausgeben
puts Color.paint(logo, :cyan)
puts Color.paint("─" * 65, :magenta)

# CLI-Optionen
show_help = false
export_markdown = false
username = ""

OptionParser.parse do |parser|
  parser.banner = "\nCrystal GitHub Analyzer - Analyse von GitHub-Profilen\n\nNutzung:\n  crystal run src/github_analyzer.cr -- [Optionen] <github-username>\n"
  parser.on("--help", "Zeigt diese Hilfe an") { show_help = true }
  parser.on("--markdown", "Exportiert die Analyse als Markdown-Datei") { export_markdown = true }
end

if show_help || ARGV.size == 0
  help = Color.paint(logo, :cyan) + "\n" +
         Color.paint("─" * 65, :magenta) + "\n" +
         "Crystal GitHub Analyzer\n\n" +
         "Nutzung:\n  crystal run src/github_analyzer.cr -- [Optionen] <github-username>\n\n" +
         "Optionen:\n  --help       Zeigt diese Hilfe an\n  --markdown   Exportiert die Analyse als Markdown-Datei\n\n" +
         "Beispiel:\n  crystal run src/github_analyzer.cr -- jakubbbdev\n  crystal run src/github_analyzer.cr -- --markdown jakubbbdev\n" +
         Color.paint("─" * 65, :magenta)
  puts help
  exit 0
end

username = ARGV.last
puts Color.paint(logo, :cyan)
puts Color.paint("─" * 65, :magenta)
puts Color.paint("Analysiere GitHub-Profil von #{username}...", :cyan)
puts Color.paint("─" * 65, :magenta)

user_json = fetch_user(username)
require "json"
user = JSON.parse(user_json)

repos_json = fetch_repos(username)
repos = JSON.parse(repos_json).as_a

puts Color.paint("\nName: ", :yellow) + Color.paint(user["name"]?.to_s, :green)
puts Color.paint("Public Repos: ", :yellow) + Color.paint(user["public_repos"].to_s, :green)
puts Color.paint("Follower: ", :yellow) + Color.paint(user["followers"].to_s, :green)
puts Color.paint("Folgt: ", :yellow) + Color.paint(user["following"].to_s, :green)
puts Color.paint("Profil: ", :yellow) + Color.paint(user["html_url"].to_s, :blue)

langs = top_languages(repos)
puts Color.paint("\nTop 3 Sprachen:", :green)
langs.each_with_index do |lang, i|
  puts Color.paint("  #{i+1}. #{lang}", :light_green)
end

# Top 3 Repos nach Stars
puts Color.paint("\nTop 3 Repos nach Stars:", :blue)
top_repos = repos.sort_by { |repo| -repo["stargazers_count"].as_i }[0,3]
top_repos.each_with_index do |repo, i|
  name = repo["name"].to_s
  stars = repo["stargazers_count"].as_i.to_s
  lang = repo["language"]?.to_s
  url = repo["html_url"].to_s
  puts Color.paint("  #{i+1}. #{name} (#{lang}) ", :light_green) + Color.paint("★#{stars}", :yellow) + " - " + Color.paint(url, :cyan)
end

puts Color.paint("\nAktivitätsübersicht (Repos pro Jahr):", :magenta)
years = Hash(String, Int32).new(0)
repos.each do |repo|
  year = repo["created_at"].to_s[0,4]
  years[year] += 1
end
# ASCII-Balkendiagramm
max_count = years.values.max? || 1
bar_unit = 30.0 / max_count
years.to_a.sort_by { |(y, _)| y }.each do |year, count|
  bar = Color.paint("█" * ((count * bar_unit).round.to_i), :light_magenta)
  puts Color.paint("  #{year}: ", :yellow) + Color.paint(count.to_s.rjust(2), :green) + " " + bar
end

puts Color.paint("\n" + "═" * 65, :magenta)
puts Color.paint("Fertig!", :cyan)

if export_markdown
  md = "# GitHub-Profil-Analyse: #{username}\n\n"
  md += "**Name:** #{user["name"]?.to_s}\n\n"
  md += "**Public Repos:** #{user["public_repos"].to_s}\n"
  md += "**Follower:** #{user["followers"].to_s}\n"
  md += "**Folgt:** #{user["following"].to_s}\n"
  md += "**Profil:** [#{user["html_url"].to_s}](#{user["html_url"].to_s})\n\n"
  md += "## Top 3 Sprachen\n"
  langs.each_with_index do |lang, i|
    md += "- #{i+1}. #{lang}\n"
  end
  md += "\n## Top 3 Repos nach Stars\n"
  top_repos.each_with_index do |repo, i|
    name = repo["name"].to_s
    stars = repo["stargazers_count"].as_i.to_s
    lang = repo["language"]?.to_s
    url = repo["html_url"].to_s
    md += "- [#{name}](#{url}) (#{lang}) ★#{stars}\n"
  end
  md += "\n## Aktivitätsübersicht (Repos pro Jahr)\n"
  years.to_a.sort_by { |(y, _)| y }.each do |year, count|
    md += "- #{year}: #{count}\n"
  end
  File.write("github_#{username}_analyse.md", md)
  puts Color.paint("\nAnalyse als github_#{username}_analyse.md gespeichert!", :green)
end 