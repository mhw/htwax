module HtWax
  class Response
    def initialize(request, response)
      @request = request
      @status_code = response.status
    end

    attr_reader :request
    attr_reader :status_code
  end
end
