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

  end
end
