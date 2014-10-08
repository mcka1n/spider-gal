require 'nokogiri'
require 'open-uri'

class PolyvoreProductWorker
  include Sidekiq::Worker

  def perform(link_to_scrape)
    # spider-girl phase # 2
    # get products from collage source

    browser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"
    #link_to_scrape = 'http://www.polyvore.com/uniqlo_women_sprz_ny_long/set?id=135102486'
    collage_doc = Nokogiri::HTML(open(link_to_scrape, 'User-Agent' => browser))
    image = collage_doc.css('.main_img a img').attribute('src').content

    product_lis = collage_doc.at_css('.layout_grid')
    product_lis = product_lis.css('li')

    counter = 0
    product_lis.each do |li|
      # div class main
      if li.at_css('.grid_item .main a img')
        counter = counter + 1

        product_image = li.at_css('.grid_item .main a img').attribute('src').content

        brand_product_name = li.at_css('.grid_item .main a img').attribute('title').content

        # div class under
        if li.at_css('.grid_item .under .price_and_link')

          if price = li.at_css('.grid_item .under .price_and_link .price')
            price = li.at_css('.grid_item .under .price_and_link .price').content
          end

          if li.at_css('.grid_item .under .price_and_link a')
            buy_link = li.at_css('.grid_item .under .price_and_link a').get_attribute('href').to_s
          end
        end

        SpiderGirl.logger.debug "[spider-girl] PolyvoreProductWorker --> [#{counter}]: #{brand_product_name} @ #{price}"

        # DO THE POST
        CreateProductWorker.perform_async(brand_product_name,
                                          product_image,
                                          buy_link,
                                          price,
                                          price,
                                          'Browsy',
                                          link_to_scrape)

      end
    end

  end

end
