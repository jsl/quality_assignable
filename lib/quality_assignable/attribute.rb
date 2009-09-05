module QualityAssignable
  
  class Attribute    
    include Comparable
    
    attr_reader :content, :quality

    def initialize(content, quality = :default)
      @valid_qualities = QualityAssignable::Constants::DEFAULT_QUALITIES

      @content  = content
      self.quality  = quality
    end

    def self.from_merge(*args)
      args.sort.reverse.first
    end

    def quality=(value)
      @quality = if @valid_qualities.keys.include?(value)
        value
      elsif @valid_qualities.values.include?(value)
        @valid_qualities[value]
      elsif value == :default
        :default
      else
        raise "Value #{value} is not in list of valid qualities"
      end
    end

    def quality
      @quality
    end

    # Returns an integer representation of this object's quality
    def quality_val
      @valid_qualities[@quality]
    end

    # Prefers elements that have content over those that have nil content.
    # Otherwise, rank higher those elements that have a higher quality.
    def <=>(other)
      # If both elements are either nil or have content, compare by quality
      # value.  Otherwise, rank the element with non-nil content higher than
      # +other+.
      if [ self, other ].select{ |x| x.content.nil? }.size % 2 == 0
        self.quality_val <=> other.quality_val
      else
        self.content.nil? ? -1 : 1
      end
    end
  end
  
end