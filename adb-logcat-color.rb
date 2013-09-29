#!/usr/bin/ruby

require 'rubygems'
require 'smart_colored/extend'

VERBOSE = 0
DEBUG   = 1
INFO    = 2
WARNING = 3
ERROR   = 4
FATAL   = 5
SILENT  = 6

DEFAULT_LEVEL = DEBUG

$patterns = {"V/" => {:fg => "black", :bg => "blue",    :label => "[ VERBOSE ]", :level => VERBOSE},
            "D/" => {:fg => "black", :bg => "cyan",    :label => "[  DEBUG  ]", :level => DEBUG},
            "I/" => {:fg => "black", :bg => "green",   :label => "[  INFO   ]", :level => INFO},
            "W/" => {:fg => "black", :bg => "yellow",  :label => "[ WARNING ]", :level => WARNING},
            "E/" => {:fg => "black", :bg => "red",     :label => "[  ERROR  ]", :level => ERROR},
            "F/" => {:fg => "black", :bg => "magenta", :label => "[  FATAL  ]", :level => FATAL},
            "S/" => {:fg => "black", :bg => "white",   :label => "[  SILENT ]", :level => SILENT}}



def colorize_line(line)
  line.sub!(/\(\s*\d+\)/, "")
  line.gsub!("\r\n", "")

  match = $patterns.keys.find do |x|
    line.start_with?(x)
  end

  if match
    line.sub!(match, " => ")
    label = $patterns[match][:label]
    fg = $patterns[match][:fg]
    bg = $patterns[match][:bg]
    level = $patterns[match][:level]
    if filter_log?(level)
      print label.send("#{fg}_on_#{bg}")
      puts line.send("#{bg}_on_#{fg}")
    end
  end
end

def filter_log?(level)
  level >= DEFAULT_LEVEL
end

use_argf=ARGV.length == 1 and File.exists?(ARGV[0])

if use_argf then
  ARGF.each do |line|
    colorize_line(line)
  end
else
  # Ruby 1.9 support passing an array - move to this eventually
  IO.popen("adb logcat #{ARGV.join(' ')}") do |f|
    while line = f.gets
      colorize_line(line)
    end
  end
end
