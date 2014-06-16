module HtWax
  module HasOptions
    def default_options
      Options.new.tap do |opts|
        opts.connection = Faraday.new
      end
    end

    def connection
      @options.connection
    end
  end
end
