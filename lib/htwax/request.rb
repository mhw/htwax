module HtWax
  class Request
    include HasOptions

    def initialize(request_method, uri, options = default_options)
      @request_method = request_method
      @uri = uri
      @options = options
    end

    attr_reader :request_method, :uri

    def go
      Response.new(self, connection.run_request(request_method, uri, nil, nil))
    end
  end
end
