require 'rubygems'
require 'activerecord'

require File.join(File.dirname(__FILE__), 'spec_helper')

ActiveRecord::Base.silence do
  ActiveRecord::Schema.define do
    create_table :coffee_mugs do |table|
      table.integer :quality_score
      table.integer :crazy_quality_score
    end

    create_table :water_glasses do |table|
    end
  end
end


describe "quality_assignable_model" do
  class CoffeeMug < ActiveRecord::Base
    quality_assignable_model
  end
  
  describe "quality_assignable_model" do
    it "should raise an error if the class doesn't have a 'quality_score' column" do
      lambda {
        class WaterGlass < ActiveRecord::Base
          quality_assignable_model
        end
      }.should raise_error(RuntimeError, "QualityAssignable needs a column named quality_score on WaterGlass")
    end
    
    it "should be comparable with another instance of the model" do
      cm1 = CoffeeMug.new(:quality_score => :low)
      cm2 = CoffeeMug.new(:quality_score => :high)
      
      (cm1 < cm2).should be_true
    end
    
    it "should raise an error if a value is assigned that is not a valid quality" do
      lambda {
        CoffeeMug.new(:quality => :foo)
      }.should raise_error(RuntimeError, "foo is not a valid quality for a CoffeeMug")
    end
    
    it "should set the integer value for quality score when a valid value is set in quality" do
      CoffeeMug.new(:quality => :low).quality_score.should == QualityAssignable::Constants::DEFAULT_QUALITIES[:low]
    end
    
    it "should return a symbol representing the quality when #quality is called" do
      CoffeeMug.new(:quality => :low).quality.should == :low
    end
    
    it "should allow the quality column to be overridden" do
      class CrazyCoffeeMug < ActiveRecord::Base
        set_table_name "coffee_mugs"
        quality_assignable_model :quality_column => 'crazy_quality_score'
      end
      
      CrazyCoffeeMug.new(:quality => :low).quality.should == :low
    end
    
    it "should allow the valid_qualities to be overridden" do
      class WeirdCoffeeMug < ActiveRecord::Base
        set_table_name "coffee_mugs"
        quality_assignable_model :valid_qualities => {:poor => 10, :satisfactor => 20}
      end
      
      lambda { WeirdCoffeeMug.new(:quality => :poor) }.should_not raise_error
    end
  end  
end
