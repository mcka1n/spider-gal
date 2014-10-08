namespace :polyvore do
  namespace :index do
    desc "Polyvore scrapper for all collages."
    task :all => :environment do
      SpiderGirl.logger.info "[rake task] Marichi funky disco! :D"
    end
  end
end
