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


      end
    end
  end
end
