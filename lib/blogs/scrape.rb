require 'httparty'
require 'json'
require 'csv'

module SpiderGirl
  module Blogs
    module Scrape
      class Base < SpiderGirl::Base

        attr_reader :blog, :url, :next, :response

        def initialize(blog, args = nil)
          @blog = blog.to_sym
          @url = config.blogs[blog.to_s]["url"].to_sym
          @next = config.blogs[blog.to_s]["next"]
          @response = nil
        end

        def run
          # to be defined by child
        end

        def clean_product_name sentence
          #sentence = "levis 501 commuter jeans 30x32"
          default_brand = "Browsy Brand"
          words = sentence.split(' ')
          result = {:product_name => sentence, :brand => default_brand}

          words.each do |word|
            matches = BrandCatalog.where("name LIKE ?", "%#{word}%")
            if matches.count > 0
              brand = matches.first
              sentence.slice! brand
              result = {:product_name => sentence, :brand => brand}
              break
            end
          end

          result
        end

      end
    end
  end
end
