require 'test_helper'

module HtWax
  describe Request do
    describe 'initialize' do
      it 'can be initialized with an http method and a URI' do
        r = Request.new(:get, 'http://localhost/')

        r.request_method.must_equal :get
        r.uri.must_equal 'http://localhost/'
      end
    end

    let(:req) { Request.new(:get, 'http://localhost/') }

    describe 'go' do
      it 'returns the Response' do
        stub = stub_request(:get, 'http://localhost/')

        response = req.go

        stub.must_have_been_requested
        response.must_be_kind_of Response
        response.request.must_be_same_as req
        response.status_code.must_equal 200
      end
    end
  end
end
