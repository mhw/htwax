require 'test_helper'

module HtWax
  describe Link do
    describe 'setting arguments' do
      subject { Link.new }

      it 'should allow arguments to be set and read' do
        subject[:arg] = 'some value'
        subject[:arg].must_equal 'some value'
      end
    end
  end
end
