class HardWorker
  include Sidekiq::Worker
  def perform(name, count)
    # do something
    p "Hello Hard Worker"
  end
end
