require 'htwax'
require 'minitest/autorun'
require 'webmock/minitest'

WebMock::RequestStub.infect_an_assertion :assert_requested, :must_have_been_requested, :unary
