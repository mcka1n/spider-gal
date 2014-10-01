# configuration.rb

module SpiderGirl
  class Configuration

    def initialize(environment = nil)
      @config = load_config_files
    end

    private

    def load_config_files(environment = SpiderGirl.env)
      config = load_config_file(environment)
      blog_config = load_blog_config_file(environment)
      config.merge( {"blogs" => blog_config })
    end

    def load_config_file(environment = SpiderGirl.env)
      file = File.join(File.expand_path(Dir.pwd), "config", "config.yml")
      data = YAML::load(IO.read(file))

      unless configuration = data[environment]
        raise "#{file} format error: no root '#{environment}' entry"
      end

      configuration
    end

    def load_blog_config_file(environment = SpiderGirl.env)
      file = File.join(File.expand_path(Dir.pwd), "config", "blogs.yml")
      data = YAML::load(IO.read(file))
      data
    end

  end
end
