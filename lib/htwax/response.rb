module HtWax
  class Response
    def initialize(request)
      @request = request
    end

    attr_reader :request
  end
end
