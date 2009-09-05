require 'rubygems'
require 'activerecord'

require File.join(File.dirname(__FILE__), %w[.. spec_helper])

ActiveRecord::Base.silence do
  ActiveRecord::Schema.define do
    create_table :tacos do |table|
      table.string :salsa
      table.integer :salsa_quality_score
    end
  end

end

describe QualityAssignable::Attribute do
  
  describe "integration into AR models" do
    describe "without the quality_score column" do
      it "should raise an error if the model doesn't have a column with the attribute name appended with quality_score'" do
        lambda {
          ActiveRecord::Schema.define do
            create_table :burritos do |table|
              table.string :salsa
            end
          end  
          
          class Burritos < ActiveRecord::Base
            quality_assignable_attribute :salsa
          end
        }.should raise_error(RuntimeError)
      end      
    end
  
    describe "with the quality_score column" do
      class Taco < ActiveRecord::Base
        quality_assignable_attribute :salsa
      end
      
      it "should return a AttributeWithQuality when the _quality method is called on the attribute" do
        t = Taco.new(:salsa_with_quality => QualityAssignable::Attribute.new('spicy', :low))
        t.salsa_with_quality.should be_a(QualityAssignable::Attribute)
      end
      
      it "should raise an error when an invalid quality is given" do
        t = Taco.new
        lambda {
          t.salsa_with_quality = QualityAssignable::Attribute.new('hey', :foo)          
        }.should raise_error
      end
    end
  end
  
  describe "comparable functionality" do
    it "should sort objects in order of increasing quality" do
      t1 = Taco.new(:salsa_with_quality => QualityAssignable::Attribute.new('spicy', :low))
      t2 = Taco.new(:salsa_with_quality => QualityAssignable::Attribute.new('spicy', :high))
      t3 = Taco.new(:salsa_with_quality => QualityAssignable::Attribute.new('spicy', :medium))
      
      sorted = [t1, t2, t3].map(&:salsa_with_quality).sort.reverse
      sorted.first.should == t2.salsa_with_quality
      sorted.last.should == t1.salsa_with_quality
    end
    
    it "should have a :default quality if none is specified" do
      QualityAssignable::Attribute.new('spicy').quality.should == :default
    end
  end
  
  describe "providing a custom value object class" do
    class MyQualityClass < QualityAssignable::Attribute
    end
    
    class Bean < ActiveRecord::Base
      set_table_name 'tacos'
      
      quality_assignable_attribute :salsa, :class_name => "MyQualityClass"
    end
    
    it "should return the custom class when the value object method is called" do
      Bean.new(:salsa_with_quality => MyQualityClass.new('spicy', :low)).salsa_with_quality.should be_a(MyQualityClass)
    end
  end
end
