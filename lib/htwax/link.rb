require 'uri/common'

module HtWax
  class Link
    include HasOptions

    def initialize(*args)
      if args.last.is_a?(Hash)
        @preset = symbolize_keys(args.pop)
      else
        @preset = {}
      end
      case args.length
      when 1
        @request_method = :get
        @uri = args[0]
        @options = default_options
      when 2
        if args[1].instance_of?(Options)
          @request_method = :get
          @uri = args[0]
          @options = args[1]
        else
          @request_method = args[0].to_sym
          @uri = args[1]
          @options = default_options
        end
      when 3
        unless args[2].instance_of?(Options)
          raise ArgumentError, "third argument should be Options, was #{args[2].class.name}"
        end
        @request_method = args[0].to_sym
        @uri = args[1]
        @options = args[2]
      else
        raise ArgumentError, "no URI passed to Link#new"
      end
      yield @options if block_given?
      reset
    end

    attr_reader :request_method

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

    def to_uri
      query = URI.encode_www_form(each)
      if query.empty?
        @uri
      else
        @uri + '?' + query
      end
    end

    alias :to_s :to_uri

    def new_request
      Request.new(@request_method, self.to_s)
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
