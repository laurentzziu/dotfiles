#!/usr/bin/ruby

# see http://lucapette.com/pry/pry-everywhere/
require 'rails/console/app'
extend Rails::ConsoleMethods

# rvm @global do gem install gem_name
#
# https://github.com/carlhuda/bundler/issues/183#issuecomment-1149953
if defined?(::Bundler) || File.exists?('Gemfile')
  global_gemset = ENV['GEM_PATH'].split(':').grep(/ruby.*@global/).first
  if global_gemset
    all_global_gem_paths = Dir.glob("#{global_gemset}/gems/*")
    all_global_gem_paths.each do |p|
      gem_path = "#{p}/lib"
      $LOAD_PATH << gem_path
    end
  end
end

# Pry editor, using the 'edit' command
Pry.config.editor = "vim"

# My pry is polite
Pry.config.hooks.add_hook(:after_session, :say_goodbye) do
  puts "Bye, love!"
end

%w[awesome_print pry-doc pry-nav].each  do |gem|
  begin
    require gem
    if gem == "pry-nav"
      Pry.commands.alias_command 'c', 'continue'
      Pry.commands.alias_command 's', 'step'
      Pry.commands.alias_command 'n', 'next'
    end
  rescue LoadError
    warn "could not load #{gem}"
   end
end

# LOOKSEE
begin
  require "looksee"

  module PryLookseeCompatibility
    def ls *args
      if Pry.color
        Pry.color = false
        p super
        Pry.color = true
      nil
      else
        super
      end
    end
  end

  Object.send(:include, PryLookseeCompatibility)
rescue LoadError
    warn "could not load looksee!"
end

# Colored prompt
Pry.prompt = [
  proc { |target_self, nest_level, pry|
        "[#{pry.input_array.size}]\001\e[0;32m\002#{Pry.config.prompt_name}\001\e[0m\002(\001\e[0;33m\002#{Pry.view_clip(target_self)}\001\e[0m\002)#{":#{nest_level}" unless nest_level.zero?}> "
       },
  proc { |target_self, nest_level, pry|
        "[#{pry.input_array.size}]\001\e[1;32m\002#{Pry.config.prompt_name}\001\e[0m\002(\001\e[1;33m\002#{Pry.view_clip(target_self)}\001\e[0m\002)#{":#{nest_level}" unless nest_level.zero?}* "
       }
  ]


