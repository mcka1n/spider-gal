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
#require 'blogs'
require 'logger'
require 'bundler/setup'
require 'shopsense'

module SpiderGirl
  def self.env
    ENV['SPIDER_GIRL_ENV'] ||= 'development'
  end

  def self.root
    File.expand_path(Dir.pwd)
  end

  def self.logger
    Logger.new(STDOUT)
    Logger.new("log/#{SpiderGirl.env}.log", 10, 1024000)
  end

  def self.persist_to_file links_array
    File.open("log/polyvore_index_links.txt", "w+") do |f|
      f.puts(links_array)
    end
  end

  def self.ask_shopstyle_for product_name
    initialize_shopstyle
    api = Shopsense.api
    result = []
    products_found = api.products({ :query => "#{product_name}" })

    if products_found[:metadata][:total] > 0
      result = {:name => products_found[:products].first[:name],
                :image_url => products_found[:products].first[:image][:sizes][:Large][:url],
                :buy_link => products_found[:products].first[:clickUrl],
                :original_price => products_found[:products].first[:priceLabel],
                :current_price => products_found[:products].first[:salePriceLabel] || products_found[:products].first[:priceLabel],
                :brand => products_found[:products].first[:brand][:name]
               }
    end

    result
  end

  protected

  def self.initialize_shopstyle
    Shopsense.configuration = YAML.load_file('config/shopsense.yml')
  end

end

# require /initializers
# Dir["#{spider_girl.root}/config/initializers/**/*.rb"].each {|f| load f}

# workers
Dir[File.expand_path('lib/workers/**/*.rb')].each{ |f| require f }
