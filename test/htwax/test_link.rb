require 'test_helper'

module HtWax
  describe Link do
    let(:link) { Link.new('http://localhost/') }
    let(:q)    { Link.new('https://www.google.co.uk/search', q: 'htwax') }

    describe 'base' do
      it 'returns the URI without the query part' do
        link.base.must_equal 'http://localhost/'
        q.base.must_equal 'https://www.google.co.uk/search'
      end
    end

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

      it 'allows presets to be cleared' do
        q[:q] = nil
        q[:q].must_be_nil
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

    describe 'initialize' do
      it 'can be initialized with a URI' do
        l = Link.new('https://www.google.co.uk/search')
        l.base.must_equal 'https://www.google.co.uk/search'
        l.empty?.must_equal true
      end

      it 'can be initialized with a URI and a hash' do
        l = Link.new('http://localhost/', { one: '1', two: '2' })
        l.base.must_equal 'http://localhost/'
        l[:one].must_equal '1'
        l[:two].must_equal '2'
      end

      it 'takes a copy of the hash passed to it' do
        h = { one: '1', two: '2' }
        l = Link.new('http://localhost/', h)
        h[:three] = '3'
        l[:three].must_be_nil
      end

      it 'can be initialized using strings as keys' do
        l = Link.new('http://localhost/', { 'one' => '1', 'two' => '2' })
        l[:one].must_equal '1'
        l[:two].must_equal '2'
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

    describe 'to_s' do
      it 'converts a bare URI to itself' do
        link.to_s.must_equal 'http://localhost/'
      end

      it 'converts a link with parameters correctly' do
        q.to_s.must_equal 'https://www.google.co.uk/search?q=htwax'
      end
    end
  end
end
