require 'test_helper'

module HtWax
  describe Link do
    let(:link) { Link.new }
    let(:q)    { Link.new(q: 'htwax') }

    describe '[]' do
      it 'returns the value' do
        q[:q].must_equal 'htwax'
        q['q'].must_equal 'htwax'
      end

      it 'returns nil if the key has no value' do
        q[:nonexistent].must_be_nil
        q['nonexistent'].must_be_nil
        q[nil].must_be :nil?
      end
    end

    describe '[]=' do
      it 'sets new values' do
        link[:arg] = 'some value'
        link['arg2'] = 'another value'

        link[:arg].must_equal 'some value'
        link['arg'].must_equal 'some value'
        link[:arg2].must_equal 'another value'
        link['arg2'].must_equal 'another value'
      end
    end

    describe 'empty?' do
      it 'returns false when arguments set' do
        q.empty?.must_equal false
      end

      it 'returns true when no arguments set' do
        link.empty?.must_equal true
      end

      it 'changes when new values are added' do
        link[:n] = 'v'
        link.empty?.must_equal false
      end
    end

    describe 'reset' do
      it 'allows preset values to be set and cleared' do
        q[:q] = 'REST'
        q[:q].must_equal 'REST'
        q.reset
        q[:q].must_equal 'htwax'
      end

      it 'allows non-preset values to be set and cleared' do
        q[:arg] = 'REST'
        q[:q].must_equal 'htwax'
        q[:arg].must_equal 'REST'
        q.reset
        q[:q].must_equal 'htwax'
        q[:arg].must_be_nil
      end
    end
  end
end
