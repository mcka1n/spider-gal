require 'nokogiri'
require 'open-uri'
require 'rake'

Bundler.require :default

class GalMeetsGlamProductWorker
  include Sidekiq::Worker

  def perform(link_to_scrape)
    # spider-girl phase # 2
    # get products from  source

    browser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"
    collage_doc = Nokogiri::HTML(open(link_to_scrape, 'User-Agent' => browser))

    product_anchors = collage_doc.css('.source-text a')

    counter = 0
    product_anchors.each do |anchor|
      raw_product_url = anchor.get_attribute('href').to_s

      SpiderGirl.logger.debug "[spider-girl] GalMeetsGlamProductWorker --> #{raw_product_url} - # - [#{counter}]"
      product = Nokogiri::HTML(open(raw_product_url, 'User-Agent' => browser))

      SpiderGirl.logger.info "[spider-girl] @GalMeetsGlam, Asking Shopsense for product."

      # call shopstyle
      sleep(rand(1..2)) # we don't want to freak out Shopsense right?
      result = SpiderGirl.ask_shopstyle_for product.at_css('title').content

      # DO THE POST
      CreateProductWorker.perform_async(result[:name],
                                        result[:image_url],
                                        result[:buy_link],
                                        result[:original_price],
                                        result[:current_price],
                                        result[:brand],
                                        link_to_scrape)


    end

  end

end
