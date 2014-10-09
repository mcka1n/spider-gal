require 'rake'

Bundler.require :default

class CreateProductWorker
  include Sidekiq::Worker

  def perform(name, image_url, buy_link, original_price, current_price, brand, origin_url)
    # to do
    # improve this HTTParty call grr ...

    if SpiderGirl.env == 'production'
      base_url = 'http://api.dev.browsy.com'
    else
      base_url = 'http://localhost:3000/v1/products'
    end

    # do not send post request if price is nil
    if !original_price.nil? && !current_price.nil?
      @result = HTTParty.post(base_url,
      :body => { :name => name,
                 :image_url => image_url,
                 :buy_link => buy_link,
                 :original_price => original_price,
                 :current_price => current_price,
                 :brand => 'Browsy',
                 :origin_url => origin_url
               }.to_json,
      :headers => { 'Content-Type' => 'application/json' } )
    end
  end

end
