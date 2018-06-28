require "pathname"
require "fileutils"
include FileUtils

# path to your application root.
APP_ROOT = Pathname.new File.expand_path("../../", __FILE__)

COLOR_CODES = {
  black: 30,
  blue: 34,
  brown: 33,
  cyan: 36,
  dark_gray: 90,
  green: 32,
  light_blue: 94,
  light_cyan: 96,
  light_gray: 37,
  light_green: 92,
  light_purple: 95,
  light_red: 91,
  light_yellow: 93,
  purple: 35,
  red: 31,
  white: 97,
  yellow: 33,
}.freeze

def system!(*args)
  puts colorize(light_cyan: args.join(" "))
  system(*args) || abort(colorize(light_red: "\n== Command #{args} failed =="))
end

def step(name)
  puts colorize(light_yellow: "\n== #{name} ==")
  yield
end

def colorize(colors_and_strings)
  colors_and_strings.map do |color, string|
    "\e[#{COLOR_CODES[color]}m#{string}\e[0m"
  end.join
end

def brew_installed?(formulae)
  system "brew ls --versions #{formulae}"
end

def cli_installed?(command_name)
  system "which #{command_name}"
end

def gem_installed?(gem)
  system "gem list | grep ^#{gem}[[:space:]]"
end
