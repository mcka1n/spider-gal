require 'nokogiri'
require 'open-uri'
require 'date'
require 'time'

# this string is the browser agent for Safari running on a Mac
browser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"

blog_url = "http://atlantic-pacific.blogspot.com"

doc = Nokogiri::HTML(open(blog_url, 'User-Agent' => browser))

origin_url = ""

containers = doc.css('.date-outer')
containers.each do |container|
  origin_url = container.at_css('h3 a').get_attribute('href').to_s
  p origin_url
  container.css('.post-body span a').each do |link|
    product_url = link.get_attribute('href').to_s
    # getting product name
    product = Nokogiri::HTML(open(product_url, 'User-Agent' => browser))
    title = product.at_css('title').content

    # call shopstyle
    result = SpiderGirl.ask_shopstyle_for title

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

# go to next page
next_page = doc.at_css('.blog-pager-older-link').get_attribute('href').to_s
