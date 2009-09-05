require File.join(File.dirname(__FILE__), %w[quality_assignable attribute])
require File.join(File.dirname(__FILE__), %w[quality_assignable constants])

module QualityAssignable

  def self.included(base)
    base.extend(SingletonMethods)
  end

  module SingletonMethods

    def quality_assignable_attributes(*args)
      opts = args.extract_options!

      args.each do |arg|
        col_name = "#{arg}_quality_score"
        raise "QualityAssignable needs a column named #{col_name} on #{self.name}" unless self.column_names.include?(col_name)

        value_object_method = "#{arg}_with_quality"
        class_name = opts[:class_name] || "QualityAssignable::Attribute"
        composed_of value_object_method.to_sym, :class_name => class_name, :mapping => [ [arg, 'content'], [col_name, 'quality'] ]
      end
    end
    alias :quality_assignable_attribute :quality_assignable_attributes
    
    # Makes this model comparable with other instances of the same class via
    # the required attribute #quality_score.
    def quality_assignable_model(*args)
      opts = args.extract_options!

      quality_col     = opts[:quality_column] || 'quality_score'
      valid_qualities = opts[:valid_qualities] || QualityAssignable::Constants::DEFAULT_QUALITIES

      raise "QualityAssignable needs a column named #{quality_col} on #{self.name}" unless self.column_names.include?(quality_col)
      include Comparable

      # Defines a method that returns the symbol based on the Integer stored in quality_col
      define_method(:quality) do
        valid_qualities.invert[self[quality_col]]
      end

      # Defines a method that sets the Integer for the quality score based on valid_qualities and the input symbol
      define_method(:"quality=") do |other|
        raise "#{other} is not a valid quality for a #{self.class}" unless valid_qualities.keys.include?(other)
        self[quality_col] = valid_qualities[other]
      end

      define_method(:"<=>") do |other|
        col_sym = quality_col.to_sym
        self.__send__(col_sym) <=> other.__send__(col_sym)
      end
    end
  end
  
end

ActiveRecord::Base.__send__(:include, QualityAssignable)