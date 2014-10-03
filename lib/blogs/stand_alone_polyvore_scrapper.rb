require 'nokogiri'require 'open-uri'# this string is the browser agent for Safari running on a Macbrowser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"# create a new Nokogiri HTML document from the scraped URL and pass in the# browser agent as a second parameterdoc = Nokogiri::HTML(open('http://www.polyvore.com/?filter=fashion', 'User-Agent' => browser))# we are going to take every list inside the main grid containerlis = doc.css('.layout_grid li')# spider-girl phase # 1# get a collage links listcounter = 0lis.each do |li| if li.at_css('.grid_item a')   counter = counter + 1   collage_link = li.at_css('.grid_item a').get_attribute('href').to_s   p "printing collage link[#{counter}]: #{collage_link}"   # to do:   # persist links on database   # Or push it to a queue. endend# spider-girl phase # 2# get products from collage sourcelink_to_scrape = 'http://www.polyvore.com/uniqlo_women_sprz_ny_long/set?id=135102486'collage_doc = Nokogiri::HTML(open(link_to_scrape, 'User-Agent' => browser))image = collage_doc.css('.main_img a img').attribute('src').contentproduct_lis = collage_doc.at_css('.layout_grid')product_lis = product_lis.css('li')counter = 0product_lis.each do |li|  # div class main  if li.at_css('.grid_item .main a img')    counter = counter + 1        product_image = li.at_css('.grid_item .main a img').attribute('src').content    brand_product_name = li.at_css('.grid_item .main a img').attribute('title').content    # div class under    if li.at_css('.grid_item .under .price_and_link')      if price = li.at_css('.grid_item .under .price_and_link .price')        price = li.at_css('.grid_item .under .price_and_link .price').content      end      if li.at_css('.grid_item .under .price_and_link a')        buy_link = li.at_css('.grid_item .under .price_and_link a').get_attribute('href').to_s      end    end    p "-- [#{counter}]: #{brand_product_name} @ #{price}"  endend