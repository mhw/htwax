module HtWax
  class Request
    def initialize(method, uri)
      @method = method
      @uri = uri
    end

    attr_reader :method, :uri
  end
end
