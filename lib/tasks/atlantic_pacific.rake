require 'nokogiri'
require 'open-uri'
require 'date'
require 'time'

namespace :atlantic_pacific do
  namespace :index do
    desc "Atlantic Pacific scrapper for all posts."
    task :all, [:page] => :environment do |t, args|
      args.with_defaults(:page => nil)
      page = args.page

      browser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"
      blog_url = "http://atlantic-pacific.blogspot.com"
      count = 0
      while count <= 182      # 182 pages divided in 4 post per page.
        current_hour = (Time.now.utc + Time.zone_offset("PDT")).hour    # in SF Time.

        if (current_hour >= 8 && current_hour <= 18)
          SpiderGirl.logger.info "[spider-girl] @AP worker processing #{count}/182 with page: #{blog_url}"

          doc = Nokogiri::HTML(open(blog_url, 'User-Agent' => browser))
          containers = doc.css('.date-outer')

          containers.each do |container|
            origin_url = container.at_css('h3 a').get_attribute('href').to_s
            container.css('.post-body span a').each do |link|
              AtlanticPacificProductWorker.perform_async(link.get_attribute('href').to_s, origin_url)
            end
          end

          # technical sleep
          sleep(rand(2..3).minutes)

          # go to next page
          count = count + 1
          blog_url = doc.at_css('.blog-pager-older-link').get_attribute('href').to_s
        else
          # good night process :)
          SpiderGirl.logger.info "[spider-girl] @AP Pause signal. Good night Browsy, current time: #{Time.now}"
          sleep((current_hour - 8).abs.hours)
        end

      end

    end
  end
end
