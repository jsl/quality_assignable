module QualityAssignable
  
  # Stores (after checking for error conditions) the settings for an attribute or model quality
  module Constants
    
    attr_reader :default_quality, :qualities
    
    DEFAULT_QUALITY = :medium unless defined?(DEFAULT_QUALITY)

    DEFAULT_QUALITIES = {
      :low      => 20,
      :medium   => 30,
      :high     => 40
    } unless defined?(DEFAULT_QUALITIES)
    
  end
end