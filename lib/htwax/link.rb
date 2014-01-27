module HtWax
  class Link
    def initialize
      @arguments = {}
    end

    def []=(key, value)
      @arguments[key] = value
    end

    def [](key)
      @arguments[key]
    end
  end
end
