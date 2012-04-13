#!/usr/bin/ruby

require 'rubygems'
require 'smart_colored/extend'

patterns = {"V/" => {:fg => "black", :bg => "blue",    :label => "[ VERBOSE ]"},
            "D/" => {:fg => "black", :bg => "cyan",    :label => "[  DEBUG  ]"},
            "I/" => {:fg => "black", :bg => "cyan",    :label => "[  INFO   ]"},
            "W/" => {:fg => "black", :bg => "yellow",  :label => "[ WARNING ]"},
            "E/" => {:fg => "black", :bg => "red",     :label => "[  ERROR  ]"},
            "F/" => {:fg => "black", :bg => "magenta", :label => "[  FATAL  ]"},
            "S/" => {:fg => "black", :bg => "white",   :label => "[  SILENT ]"}}


# Ruby 1.9 support passing an array - move to this eventually
IO.popen("adb logcat #{ARGV.join(' ')}") do |f|
  while line = f.gets
    line.sub!(/\(\s*\d+\)/, "")
    line.gsub!("\r\n", "")

    match = patterns.keys.find do |x|
      line.start_with?(x)
    end

    if match
      line.sub!(match, " => ")
      label = patterns[match][:label]
      fg = patterns[match][:fg]
      bg = patterns[match][:bg]
      print label.send("#{fg}_on_#{bg}")
      puts line.send("#{bg}_on_#{fg}")
    end
  end
end
