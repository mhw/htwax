require 'uri/common'

module HtWax
  class Link
    def initialize(*args)
      if args.last.is_a?(Hash)
        @preset = symbolize_keys(args.pop)
      else
        @preset = {}
      end
      case args.length
      when 1
        @method = :get
        @uri = args[0]
      when 2
        @method = args[0].to_sym
        @uri = args[1]
      else
        raise ArgumentError, "no URI passed to Link#new"
      end
      reset
    end

    def method
      @method
    end

    def base
      @uri
    end

    def []=(key, value)
      @arguments[key.to_sym] = value
    end

    def [](key)
      key = key.to_sym unless key.nil?
      if @arguments.has_key?(key)
        @arguments[key]
      else
        @preset[key]
      end
    end

    def update(values = {})
      values.each_pair do |k, v|
        self[k] = v
      end
    end

    def empty?
      keys.empty?
    end

    def reset
      @arguments = {}
    end

    def keys
      nil_argument_keys = @arguments.inject([]) do |keys, (k, v)|
        if v.nil?
          keys << k
        else
          keys
        end
      end
      (@preset.keys - nil_argument_keys) + (@arguments.keys - nil_argument_keys - @preset.keys)
    end

    def each_key
      return enum_for(:each_key) unless block_given?
      keys.each do |key|
        yield key
      end
    end

    def each
      return enum_for(:each) unless block_given?
      keys.each do |key|
        yield key, self[key]
      end
    end

    def to_s
      query = URI.encode_www_form(each)
      if query.empty?
        @uri
      else
        @uri + '?' + query
      end
    end

    private
      def symbolize_keys(hash)
        hash.inject({}) do |m, (k, v)|
          m[k.to_sym] = v
          m
        end
      end
  end
end
