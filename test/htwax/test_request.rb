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

    let(:stubs) do
      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/') { [200, {}, ''] }
      end
    end

    let(:connection) do
      Faraday.new do |builder|
        builder.adapter :test, stubs
      end
    end

    let(:options) do
      Options.new.tap do |opts|
        opts.connection = connection
      end
    end

    let(:req) do
      Request.new(:get, '/', options)
    end

    describe 'go' do
      it 'returns the Response' do
        response = req.go

        stubs.verify_stubbed_calls
        response.must_be_kind_of Response
        response.request.must_be_same_as req
        response.status_code.must_equal 200
      end
    end
  end
end
