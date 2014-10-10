require 'rake'

Bundler.require :default

class HardWorker
  include Sidekiq::Worker
  #include Sidetiq::Schedulable

  #recurrence do
  #  minutes = [].tap {|a| 0.step(55, 1){|i| a << i}}
  #  hourly.minute_of_hour(*minutes)
  #end

  def perform(name, count)
    logger.info "Things are happening on the hard worker."
    logger.info "Doing hard work"
    puts '---------'
  end
end
