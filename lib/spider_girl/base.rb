require 'spider_girl/configuration'

module SpiderGirl
  class Base
    # include any logger?

    cattr_accessor :config

    def initialize(*args)
      @stop = false
    end

    def self.config
      @@config ||= SpiderGirl::Configuration.new( SpiderGirl.env )
    end

    def config
      self.class.config
    end

    def run!

      begin
        if block_given?
          yield self
        else
          # call default run method
          run
        end
      rescue Exception => e
        puts e.message
        puts e.backtrace
        stop
      end
    end

    def run
      # To be implemented by child object
    end

    def url
      config.url
    end

  end
end
