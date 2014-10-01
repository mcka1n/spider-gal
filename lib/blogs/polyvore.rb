module SpiderGirl
  module Blogs
    module Scrape
      class Polyvore < SpiderGirl::Base::Scrape::Base

        def initialize(args = nil)
          super :polyvore, args
        end

        def run
          # scrape the mtf
        end

      end
    end
  end
end
