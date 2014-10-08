#!/usr/bin/env ruby
libdir = File.expand_path( File.join(File.dirname(__FILE__), 'lib') )
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'spider_girl'
Dir[File.join(File.dirname(__FILE__),'lib/tasks/*.rake')].each { |f| load f }
