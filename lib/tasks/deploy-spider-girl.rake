require_relative 'deploy'

namespace :spider_girl do
  namespace :service do

    desc "Stop spider_girl service"
    task :stop, :environment do |t, args|
      args.with_defaults(:environment => 'development')
      deploy = Browsy::SpiderGirl.new(environment: args[:environment])
      deploy.execute do
        "sudo service spider_girl stop"
      end
    end

    desc "Start spider_girl service"
    task :start, :environment do |t, args|
      args.with_defaults(:environment => 'development')
      deploy = Browsy::SpiderGirl.new(environment: args[:environment])
      deploy.execute do
        "sudo service spider_girl start"
      end
    end

    desc "Restart spider_girl service"
    task :restart, :environment do |t, args|
      args.with_defaults(:environment => 'development')
      deploy = Browsy::SpiderGirl.new(environment: args[:environment])
      deploy.execute do
        "sudo service spider_girl restart"
      end
    end

    desc "Current status for spider_girl service"
    task :status, :environment do |t, args|
      args.with_defaults(:environment => 'development')
      deploy = Browsy::SpiderGirl.new(environment: args[:environment])
      deploy.execute do
        "sudo service spider_girl status"
      end
    end


    desc "View deployment logs"
    task :logs, :environment do |t, args|
      args.with_defaults(:environment => 'development')
      deploy = Browsy::SpiderGirl.new(environment: args[:environment])
      deploy.execute do
        "cat /tmp/puppet.log"
      end
    end

  end

  namespace :app do
    desc "Show application's log"
    task :log, :environment, :app_env do |t, args|
      args.with_defaults(:environment => 'development')
      args.with_defaults(:app_env => 'development')
      deploy = Browsy::SpiderGirl.new(environment: args[:environment], app_env: args[:app_env])
      deploy.execute do
        "tail -n 200 ~/spider_girl/log/#{args[:app_env]}.log"
      end
    end
  end


  desc "Deploy application to AWS"
  task :deploy, :environment do |t, args|
    args.with_defaults(:environment => 'development')

    deploy = Browsy::SpiderGirl.new(environment: args[:environment])
    deploy.execute do |config|
      <<-UPDATE
        sudo service spider_girl stop &&
        cd ~/spider-girl/ &&
        git stash &&
        git fetch &&
        git pull origin #{config.branch}  &&
        bundle install --path=~/.gem --without development test --clean &&
        sudo service spider_girl start
      UPDATE
    end
  end

  desc "Setup application to AWS"
  task :setup, :environment do |t, args|
    args.with_defaults(:environment => 'development')

    deploy = Browsy::SpiderGirl.new(environment: args[:environment])
    deploy.execute do |config|
      <<-UPDATE
        cd /home/ubuntu/spider-girl &&
        echo y | bundle install --path /home/ubuntu/ &&
        bundle exec foreman export -f Procfile upstart --user ubuntu --app spider_girl /etc/init &&
        sudo service spider_girl restart
      UPDATE
    end
  end
end
