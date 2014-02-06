require 'test_helper'

module HtWax
  describe Link do
    let(:link) { Link.new('http://localhost/') }
    let(:q)    { Link.new('https://www.google.co.uk/search', q: 'htwax') }
    let(:many) do
      Link.new('http://localhost/',
               one: '1', two: '2', three: '3', four: '4', five: '5')
    end

    def collect_from_each_key(link)
      keys = []
      link.each_key {|k| keys << k }
      keys
    end

    def collect_keys_and_values_from_each(link)
      keys_and_values = []
      link.each {|k, v| keys_and_values << [k, v] }
      keys_and_values
    end

    describe 'request_method' do
      it 'returns the http method when defaulted' do
        link.request_method.must_equal :get
        q.request_method.must_equal :get
      end

      it 'returns the http method when explicitly set' do
        l = Link.new(:post, 'https://www.google.co.uk/search', lang: 'en')
        l.request_method.must_equal :post
      end
    end

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

    describe 'update' do
      it 'sets multiple values at the same time' do
        link.update(arg1: '1', arg2: '2', 'arg3' => '3')

        link[:arg1].must_equal '1'
        link[:arg2].must_equal '2'
        link[:arg3].must_equal '3'
      end
    end

    describe 'empty?' do
      it 'returns false when arguments set' do
        q.wont_be_empty
      end

      it 'returns true when no arguments set' do
        link.must_be_empty
      end

      it 'changes when new values are added' do
        link[:n] = 'v'
        link.wont_be_empty
      end

      it 'allows nil arguments to override presets' do
        q[:q] = nil
        q.must_be_empty
      end
    end

    describe 'initialize' do
      it 'raises an error if no arguments passed' do
        proc {
          l = Link.new()
        }.must_raise(ArgumentError)
      end

      it 'raises an error if too many arguments passed' do
        proc {
          l = Link.new(:get, 'http://localhost/', 'extra')
        }.must_raise(ArgumentError)
      end

      it 'can be initialized with a URI' do
        l = Link.new('https://www.google.co.uk/search')
        l.base.must_equal 'https://www.google.co.uk/search'
        l.must_be_empty
      end

      it 'can be initialized with a URI and a hash' do
        l = Link.new('http://localhost/', { one: '1', two: '2' })
        l.base.must_equal 'http://localhost/'
        l[:one].must_equal '1'
        l[:two].must_equal '2'
      end

      it 'can be initialized with an http method and a URI' do
        l = Link.new(:get, 'http://localhost/')
        l.request_method.must_equal :get
        l.base.must_equal 'http://localhost/'
      end

      it 'can be initialized with an http method, URI and hash' do
        l = Link.new(:post, 'https://www.google.co.uk/search', lang: 'en')
        l.request_method.must_equal :post
        l.base.must_equal 'https://www.google.co.uk/search'
        l[:lang].must_equal 'en'
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

    describe 'keys' do
      it 'returns each key from the presets in order' do
        link.keys.must_equal []
        q.keys.must_equal %i(q)
        many.keys.must_equal %i(one two three four five)
      end

      it 'returns additional keys after preset keys' do
        many[:six] = '6'
        many[:seven] = '7'
        many.keys.must_equal %i(one two three four five six seven)
      end

      it 'returns each key only once' do
        many[:three] = 'three'
        many[:six] = '6'
        many.keys.must_equal %i(one two three four five six)
      end

      it 'does not return keys that have been overridden' do
        q[:q] = nil
        q.keys.must_equal []
      end
    end

    describe 'each_key' do
      it 'yields each key from the presets in order' do
        collect_from_each_key(many).must_equal %i(one two three four five)
      end

      it 'yields each key from the presets, then any additional arguments' do
        many[:three] = 'three'
        many[:six] = '6'
        collect_from_each_key(many).must_equal %i(one two three four five six)
      end

      it 'returns an enumerator if passed no block' do
        many.each_key.must_be_kind_of Enumerator
        many.each_key.entries.must_equal %i(one two three four five)
      end
    end

    describe 'each' do
      it 'yields each key-value from the presets' do
        collect_keys_and_values_from_each(many).must_equal [
          [:one,   '1'],
          [:two,   '2'],
          [:three, '3'],
          [:four,  '4'],
          [:five,  '5'],
        ]
      end

      it 'yields each key-value from the presets, then any additional arguments' do
        many[:three] = 'three'
        many[:six] = '6'
        collect_keys_and_values_from_each(many).must_equal [
          [:one,   '1'],
          [:two,   '2'],
          [:three, 'three'],
          [:four,  '4'],
          [:five,  '5'],
          [:six,   '6'],
        ]
      end

      it 'nil arguments override presets' do
        many[:one] = nil
        many[:three] = nil
        many[:five] = nil
        many[:six] = nil
        collect_keys_and_values_from_each(many).must_equal [
          [:two,   '2'],
          [:four,  '4'],
        ]
      end

      it 'returns an enumerator if passed no block' do
        many[:three] = 'three'
        many[:six] = '6'
        many.each.must_be_kind_of Enumerator
        many.each.entries.must_equal [
          [:one,   '1'],
          [:two,   '2'],
          [:three, 'three'],
          [:four,  '4'],
          [:five,  '5'],
          [:six,   '6'],
        ]
      end
    end

    describe 'to_uri' do
      it 'converts a bare URI to itself' do
        link.to_uri.must_equal 'http://localhost/'
      end

      it 'converts a link with parameters correctly' do
        q.to_uri.must_equal 'https://www.google.co.uk/search?q=htwax'
      end

      it 'converts additional parameters into query' do
        q[:lang] = 'en'
        q.to_uri.must_equal 'https://www.google.co.uk/search?q=htwax&lang=en'
      end

      it 'removes nil parameters from query' do
        q[:q] = nil
        q.to_uri.must_equal 'https://www.google.co.uk/search'
      end
    end

    describe 'to_s' do
      it 'is the same method as to_uri' do
        link.method(:to_s).must_equal link.method(:to_uri)
      end
    end

    describe 'new_request' do
      it 'builds a Request object with a bare URI' do
        req = link.new_request

        req.must_be_kind_of Request
        req.request_method.must_equal link.request_method
        req.uri.must_equal 'http://localhost/'
      end
    end
  end
end
