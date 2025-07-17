require "crest"
require "option_parser"

module Color
  @@enabled = true
  def self.enable(flag : Bool)
    @@enabled = flag
  end
  def self.code(name : Symbol) : String
    return "" unless @@enabled
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

def top_languages(repos)
  langs = Hash(String, Int32).new(0)
  repos.each do |repo|
    lang = repo["language"]?.to_s
    langs[lang] += 1 unless lang.empty?
  end
  langs.to_a.sort_by { |(_, v)| -v }[0, 3].map(&.first)
end

def fetch_user(username : String)
  Crest.get("https://api.github.com/users/#{username}").body
end

def fetch_repos(username : String)
  Crest.get("https://api.github.com/users/#{username}/repos?per_page=100").body
end

logo = <<-LOGO
   ____ _ _   _     _     _     _                 _             
  / ___(_) |_| |__ (_)___| |__ (_)_ __ ___   __ _| |_ ___  _ __ 
 | |  _| | __| '_ \| / __| '_ \| | '_ ` _ \ / _` | __/ _ \| '__|
 | |_| | | |_| | | | \__ \ | | | | | | | | | (_| | || (_) | |   
  \____|_|\__|_| |_|_|___/_| |_|_| |_| |_|[35m\__,_|[0m\u001b[36m\__\___/|_|   
LOGO

show_help = false
export_markdown = false
username = ""
top_n = 3
no_color = false

OptionParser.parse do |parser|
  parser.banner = "\nCrystal GitHub Analyzer - Analyze GitHub profiles\n\nUsage:\n  crystal run src/github_analyzer.cr -- [options] <github-username>\n"
  parser.on("--help", "Show this help") { show_help = true }
  parser.on("--markdown", "Export analysis as Markdown file") { export_markdown = true }
  parser.on("--top N", "Show top N repos (default: 3)") { |n| top_n = n.to_i }
  parser.on("--no-color", "Disable colored output") { no_color = true }
end

Color.enable(!no_color)

if show_help || ARGV.size == 0
  help = Color.paint(logo, :cyan) + "\n" +
         Color.paint("─" * 65, :magenta) + "\n" +
         "Crystal GitHub Analyzer\n\n" +
         "Usage:\n  crystal run src/github_analyzer.cr -- [options] <github-username>\n\n" +
         "Options:\n  --help       Show this help\n  --markdown   Export analysis as Markdown file\n  --top N      Show top N repos (default: 3)\n  --no-color   Disable colored output\n\n" +
         "Example:\n  crystal run src/github_analyzer.cr -- jakubbbdev\n  crystal run src/github_analyzer.cr -- --markdown jakubbbdev\n" +
         Color.paint("─" * 65, :magenta)
  puts help
  exit 0
end

username = ARGV.last
puts Color.paint(logo, :cyan)
puts Color.paint("─" * 65, :magenta)
puts Color.paint("Analyzing GitHub profile: #{username}...", :cyan)
puts Color.paint("─" * 65, :magenta)

user_json = fetch_user(username)
require "json"
user = JSON.parse(user_json)

repos_json = fetch_repos(username)
repos = JSON.parse(repos_json).as_a

# Gesamtstars, Forks, Lizenzen
stars = repos.sum { |repo| repo["stargazers_count"].as_i }
forks = repos.sum { |repo| repo["forks_count"].as_i }
licenses = Hash(String, Int32).new(0)
repos.each do |repo|
  lic = "None"
  if lic_json = repo["license"]?
    if lic_hash = lic_json.as_h?
      lic = lic_hash["spdx_id"]?.to_s
    end
  end
  licenses[lic] += 1 unless lic.empty?
end
most_license = "None"
if max = licenses.max_by? { |_, v| v }
  most_license = max[0]
end

puts Color.paint("\nName: ", :yellow) + Color.paint(user["name"]?.to_s, :green)
puts Color.paint("Public Repos: ", :yellow) + Color.paint(user["public_repos"].to_s, :green)
puts Color.paint("Followers: ", :yellow) + Color.paint(user["followers"].to_s, :green)
puts Color.paint("Following: ", :yellow) + Color.paint(user["following"].to_s, :green)
puts Color.paint("Profile: ", :yellow) + Color.paint(user["html_url"].to_s, :blue)
puts Color.paint("Total Stars: ", :yellow) + Color.paint(stars.to_s, :magenta)
puts Color.paint("Total Forks: ", :yellow) + Color.paint(forks.to_s, :magenta)
puts Color.paint("Most used license: ", :yellow) + Color.paint(most_license, :magenta)

langs = top_languages(repos)
puts Color.paint("\nTop 3 Languages:", :green)
langs.each_with_index do |lang, i|
  puts Color.paint("  #{i+1}. #{lang}", :light_green)
end

# Top N Repos nach Stars
puts Color.paint("\nTop #{top_n} Repos by Stars:", :blue)
top_repos = repos.sort_by { |repo| -repo["stargazers_count"].as_i }[0,top_n]
top_repos.each_with_index do |repo, i|
  name = repo["name"].to_s
  stars = repo["stargazers_count"].as_i.to_s
  lang = repo["language"]?.to_s
  url = repo["html_url"].to_s
  puts Color.paint("  #{i+1}. #{name} (#{lang}) ", :light_green) + Color.paint("★#{stars}", :yellow) + " - " + Color.paint(url, :cyan)
end

puts Color.paint("\nActivity per Year:", :magenta)
years = Hash(String, Int32).new(0)
repos.each do |repo|
  year = repo["created_at"].to_s[0,4]
  years[year] += 1
end
max_count = years.values.max? || 1
bar_unit = 30.0 / max_count
years.to_a.sort_by { |(y, _)| y }.each do |year, count|
  bar = Color.paint("█" * ((count * bar_unit).round.to_i), :light_magenta)
  puts Color.paint("  #{year}: ", :yellow) + Color.paint(count.to_s.rjust(2), :green) + " " + bar
end

puts Color.paint("\n" + "═" * 65, :magenta)
puts Color.paint("Done!", :cyan)

if export_markdown
  md = "# GitHub Profile Analysis: #{username}\n\n"
  md += "**Name:** #{user["name"]?.to_s}\n\n"
  md += "**Public Repos:** #{user["public_repos"].to_s}\n"
  md += "**Followers:** #{user["followers"].to_s}\n"
  md += "**Following:** #{user["following"].to_s}\n"
  md += "**Profile:** [#{user["html_url"].to_s}](#{user["html_url"].to_s})\n"
  md += "**Total Stars:** #{stars}\n"
  md += "**Total Forks:** #{forks}\n"
  md += "**Most used license:** #{most_license}\n"
  md += "\n## Top 3 Languages\n"
  langs.each_with_index do |lang, i|
    md += "- #{i+1}. #{lang}\n"
  end
  md += "\n## Top #{top_n} Repos by Stars\n"
  top_repos.each_with_index do |repo, i|
    name = repo["name"].to_s
    stars = repo["stargazers_count"].as_i.to_s
    lang = repo["language"]?.to_s
    url = repo["html_url"].to_s
    md += "- [#{name}](#{url}) (#{lang}) ★#{stars}\n"
  end
  md += "\n## Activity per Year\n"
  years.to_a.sort_by { |(y, _)| y }.each do |year, count|
    md += "- #{year}: #{count}\n"
  end
  File.write("github_#{username}_analyse.md", md)
  puts Color.paint("\nAnalysis saved as github_#{username}_analyse.md!", :green)
end 