require 'test_helper'

module HtWax
  describe Response do
    let(:req) { Request.new(:get, 'http://localhost/') }

    describe 'initialize' do
      it 'can be initialized with a Request object' do
        response = Response.new(req)

        response.request.must_be_same_as req
      end
    end
  end
end
