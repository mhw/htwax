module HtWax
  class Link
    def initialize(args = {})
      preset = {}
      args.each_pair do |k, v|
        preset[k.to_sym] = v
      end
      @preset = preset
      reset
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

    def empty?
      @arguments.empty? && @preset.empty?
    end

    def reset
      @arguments = {}
    end
  end
end
