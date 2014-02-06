require 'test_helper'

module HtWax
  describe Response do
    let(:req) { Request.new(:get, 'http://localhost/') }

    describe 'initialize' do
      it 'can be initialized with a Request object and a Net::HTTPResponse' do
        nh_resp = Struct.new(:code).new("200")

        response = Response.new(req, nh_resp)

        response.request.must_be_same_as req
        response.status_code.must_equal 200
      end
    end
  end
end
