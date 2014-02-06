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
  end
end
