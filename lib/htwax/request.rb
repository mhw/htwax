module HtWax
  class Request
    def initialize(request_method, uri)
      @request_method = request_method
      @uri = uri
    end

    attr_reader :request_method, :uri
  end
end
