require 'nokogiri'
require 'open-uri'
require 'date'
require 'time'

namespace :polyvore do
  namespace :index do
    desc "Polyvore scrapper for all collages."
    task :all, [:page] => :environment do |t, args|
      args.with_defaults(:page => nil)
      page = args.page

      # this string is the browser agent for Safari running on a Mac
      browser = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.124 Safari/537.36"

      if !page.nil? && page != 'page'
        blog_url = "http://www.polyvore.com/?filter=fashion&p=#{page}"
      else
        blog_url = "http://www.polyvore.com/?filter=fashion"
      end

      # create a new Nokogiri HTML document from the scraped URL and pass in the
      # browser agent as a second parameter
      SpiderGirl.logger.debug "[spider-girl] blog_url: #{blog_url}"

      doc = Nokogiri::HTML(open(blog_url, 'User-Agent' => browser))

      # we are going to take every list inside the main grid container
      lis = doc.css('.layout_grid li')

      # spider-girl phase # 1
      # get a collage links list
      counter = 0
      link_array = []
      lis.each do |li|
       if li.at_css('.grid_item a')
         counter = counter + 1
         collage_link = li.at_css('.grid_item a').get_attribute('href').to_s
         collage_link.slice!(0..2)
         collage_link = "http://www.polyvore.com/" + collage_link
         SpiderGirl.logger.debug "[spider-girl] Now queuing => link[#{counter}]: #{collage_link}"
         link_array << collage_link
       end
      end

      # now for each link, lets take it easy ...
      procesed_counter = 0
      SpiderGirl.persist_to_file link_array     # save array to file.
      total_links = link_array.count

      link_array.each do |link|
        current_hour = (Time.now.utc + Time.zone_offset("PDT")).hour    # in SF Time.

        if procesed_counter <= total_links
          if (current_hour >= 8 && current_hour <= 18)
            SpiderGirl.logger.info "[spider-girl] Processing #{procesed_counter}/#{total_links}: #{link}"
            # technical sleep
            sleep(rand(2..3).minutes)
            PolyvoreProductWorker.perform_async(link)
            procesed_counter = procesed_counter + 1
          else
            # good night process :)
            SpiderGirl.logger.info "[spider-girl] Pause signal. Good night Browsy, current time: #{Time.now}"
            sleep((current_hour - 8).abs.hours)
          end
        else
          # it's over
          SpiderGirl.logger.info "[spider-girl] Link batch has been proccesed."
        end
      end
    end
  end
end
