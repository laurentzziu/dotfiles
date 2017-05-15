#!/usr/bin/ruby
require 'rubygems'
require 'pry'
require 'irb/completion'
require 'irb/ext/save-history'

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true

# Save History between irb sessions
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Copy
def pbcopy(input)
  IO.popen('pbcopy', 'w') { |f| f << input.to_s }
end

# Paste
def pbpaste
  `pbpaste`
end

# A method for clearing the screen
def clear
  system('clear')
end

# invoke pry at the end, to load all the configuration and methods above
Pry.start

exit
