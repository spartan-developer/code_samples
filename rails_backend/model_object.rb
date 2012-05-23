class ModelObject < ActiveRecord::Base

  class << self
    def include_attributes(*additional)
      define_method :attribute_names do
        super_attrs = super()
        super_attrs.concat additional
      end
    end
  end

  self.abstract_class = true

  def attributes(*only)
    keys = only.empty? ? attribute_names : only
    puts "attributes - #{self.class.name}, keys are #{keys}"
    kvps = keys.map do |name|
      value = send(name)
      value = value.attributes if value.kind_of?(ModelObject)
      [name, value]
    end
    Hash[kvps]
  end

end
