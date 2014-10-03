# spider_girl.rb
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pp'

require "active_support"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/array/extract_options"
require "active_support/core_ext/class/attribute_accessors"
require "active_support/time"

require 'spider_girl/configuration'
require 'spider_girl/base'
require 'spider_girl/notifier/mail'
require 'blogs'

module SpiderGirl
  def self.env
    ENV['SPIDER_GIRL_ENV'] ||= 'development'
  end

  def self.root
    File.expand_path(Dir.pwd)
  end
end

# require /initializers
Dir["#{spider_girl.root}/config/initializers/**/*.rb"].each {|f| load f}

# workers
Dir[File.expand_path('lib/workers/**/*.rb')].each{ |f| require f }

