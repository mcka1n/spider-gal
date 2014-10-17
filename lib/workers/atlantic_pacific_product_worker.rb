require 'nokogiri'
require 'open-uri'
require 'rake'

Bundler.require :default

class AtlanticPacificProductWorker
  include Sidekiq::Worker

  def perform(link_to_scrape, origin_url)
    post_url = link_to_scrape
    browser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"
    product = Nokogiri::HTML(open(post_url, 'User-Agent' => browser))

    SpiderGirl.logger.info "[spider-girl] @AP, Asking Shopsense for product."

    # call shopstyle
    result = SpiderGirl.ask_shopstyle_for product.at_css('title').content

    # DO THE POST
    CreateProductWorker.perform_async(result[:name],
                                      result[:image_url],
                                      result[:buy_link],
                                      result[:original_price],
                                      result[:current_price],
                                      result[:brand],
                                      origin_url)

  end

end
