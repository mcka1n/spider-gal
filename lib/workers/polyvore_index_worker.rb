require 'nokogiri'
require 'open-uri'

class PolyvoreIndexWorker
  include Sidekiq::Worker

  def perform(page)
    # this string is the browser agent for Safari running on a Mac
    browser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"

    # create a new Nokogiri HTML document from the scraped URL and pass in the
    # browser agent as a second parameter
    doc = Nokogiri::HTML(open('http://www.polyvore.com/?filter=fashion', 'User-Agent' => browser))

    # we are going to take every list inside the main grid container
    lis = doc.css('.layout_grid li')

    # spider-girl phase # 1
    # get a collage links list
    counter = 0
    lis.each do |li|
     if li.at_css('.grid_item a')
       counter = counter + 1
       collage_link = li.at_css('.grid_item a').get_attribute('href').to_s
       p "printing collage link[#{counter}]: #{collage_link}"

       PolyvoreProductWorker.perform_async(collage_link)
     end
    end
  end
end
