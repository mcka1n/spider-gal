require 'nokogiri'
require 'open-uri'
require 'date'
require 'time'

# this string is the browser agent for Safari running on a Mac
browser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"

blog_url = "http://atlantic-pacific.blogspot.com"

doc = Nokogiri::HTML(open(blog_url, 'User-Agent' => browser))

# we are going to take every list inside the main grid container
titles = doc.css('h3 a')
# doc.css('.date-outer h3 a').count

titles.each do |title|
  p title.content
end


containers = doc.css('.post-body') # 4
containers.each do |post|
  p "----------------------"
  p "#{post.css('span a')}"

  post.css('span a').each do |link|
    p "#{link.get_attribute('href').to_s}"
  end

  p "----------------------"
end
