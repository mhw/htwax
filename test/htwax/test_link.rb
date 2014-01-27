require 'test_helper'

module HtWax
  describe Link do
    describe '[]' do
      let(:link) { Link.new(q: 'htwax') }

      it 'returns the value' do
        link[:q].must_equal 'htwax'
        link['q'].must_equal 'htwax'
      end

      it 'returns nil if the key has no value' do
        link[:nonexistent].must_be_nil
        link['nonexistent'].must_be_nil
        link[nil].must_be :nil?
      end
    end

    describe '[]=' do
      subject { Link.new }

      it 'sets new values' do
        subject[:arg] = 'some value'
        subject['arg2'] = 'another value'

        subject[:arg].must_equal 'some value'
        subject['arg'].must_equal 'some value'
        subject[:arg2].must_equal 'another value'
        subject['arg2'].must_equal 'another value'
      end
    end

    describe 'reset' do
      subject { Link.new(q: 'htwax') }

      it 'allows preset values to be set and cleared' do
        subject[:q] = 'REST'
        subject[:q].must_equal 'REST'
        subject.reset
        subject[:q].must_equal 'htwax'
      end

      it 'allows non-preset values to be set and cleared' do
        subject[:arg] = 'REST'
        subject[:q].must_equal 'htwax'
        subject[:arg].must_equal 'REST'
        subject.reset
        subject[:q].must_equal 'htwax'
        subject[:arg].must_be_nil
      end
    end
  end
end
