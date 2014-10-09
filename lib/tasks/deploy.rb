module Browsy
  class Deployment
    attr_accessor :branch, :environment, :ssh_key, :host, :app_env

    def initialize(opts = {})
      @environment = opts.fetch(:environment, 'development')
      @app_env = opts.fetch(:app_env, 'development')
      @branch = opts.fetch(:branch, nil)
      @ssh_key = opts.fetch(:ssh_key, nil)
      @host = opts.fetch(:host, nil)
    end

    def execute
      config
      run_command(yield self)
    end

    private

    def run_command(deploy_cmd)
      cmd = <<-CMD
      ssh -i ~/.ssh/#{@ssh_key} -A ubuntu@#{@host} "#{deploy_cmd}"
CMD
      puts cmd
      puts `#{cmd}`
      puts "[deploy-info] Done!"
    end

    def config
      case @environment
      when 'development'
        @subdomain = 'dev.'
        @ssh_key ||= 'browsyproduction.pem'
        @branch ||= 'edge'
      when 'sandbox'
        @subdomain = 'sandbox.'
        @ssh_key ||= 'browsyproduction.pem'
        @branch ||= 'master'
      when 'production'
        @subdomain = ''
        @ssh_key ||= 'browsyproduction.pem'
        @branch ||= 'master'
      end
    end

  end

  class SpiderGirl < Browsy::Deployment
    def initialize(opts = {})
      super opts
      @host = "ec2-54-84-113-244.compute-1.amazonaws.com"
    end
  end

end
