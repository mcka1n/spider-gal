class CreateProductWorker
  include Sidekiq::Worker

  def perform(name, image_url, buy_link, original_price, current_price, brand_id, original_url)
    # to do
    # improve this HTTParty call grr ...

    if SpiderGirl.env == 'production'
      base_url = 'http://api.dev.browsy.com'
    else
      base_url = 'http://localhost:3020/v1/products'
    end

    @result = HTTParty.post(base_url,
    :body => { :name => name,
               :image_url => image_url,
               :buy_link => buy_link,
               :original_price => original_price,
               :current_price => current_price,
               :brand => 'Browsy',
               :original_url => original_url
             }.to_json,
    :headers => { 'Content-Type' => 'application/json' } )
  end

end
