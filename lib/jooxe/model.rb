require 'sequel'

module Jooxe
  
  # base class for all models
  class Model < Sequel::Model
    
    attr_writer :env
    attr_accessor :table_name

    def self.inherited(subclass)
      table_name = subclass.name.demodulize.tableize
    end
    
    def to_param
      if self.id.nil?
        nil
      else
        self.id.to_s
      end
      
    end
    
    private
    
    def params
      @env[:request].params
    end
    
    def route_info
      @env[:route_info]
    end
    
    def is_a_known_attribute?(attr_name)
      
      columns = route_info[:column_info]
      
      columns.has_key?(attr_name)
    end
    
    def has_method?(meth,include_private = false)
      
      #if the method name is an attribute setter then check it is a known attribute name
      if meth.to_s =~ /^(.+)=$/
        if is_a_known_attribute? $1
          true
        end
      end
      
      # if the method name is a known attribute name then return true
      if @values.has_key?(meth.to_s) || is_a_known_attribute?(meth.to_s)
        return true
      end
      
      # if it is a dynamic finder then return true
      if meth.to_s =~ /^find_by_.*$/
        true
      else
        super
      end
    end
    
    def define_setter(attr_name)
      
      # define a dynamic setter which sets the attr_name value to the value given on invocation
      class_eval <<-RUBY
      def self.#{attr_name}=(value)        
        @values[attr_name] = value  
      end                           
      RUBY
    end
    
    def define_getter(attr_name)
      self.class.send :define_method, attr_name do
        @values[attr_name] || @values[attr_name.to_s]
      end
    end
    
    def method_missing(meth, *args, &block)
      
      # if this is an attribute setter then set the attribute value in the values hash
      if meth.to_s =~ /^(.+)=$/
        if is_a_known_attribute? $1
          # @values hash is defined as an instance variable in Sequel::Model
          @values.update($1 => args)
          define_setter($1)
          return
        end
        raise "unknown attribute #{$1}"
      end
      
      # if the method is a known attribute name then return the value
      if @values.has_key?(meth.to_s) || is_a_known_attribute?(meth.to_s)
        define_getter(meth)
        return @values[meth] || @values[meth.to_s]
      end
      
      # the method name is not a known attribute 
      if meth.to_s =~ /^find_by_(.+)$/
        run_find_by_method($1, *args, &block)
      else
        super # You *must* call super if you don't handle the
        # method, otherwise you'll mess up Ruby's method
        # lookup.
      end
    end

    def run_find_by_method(attrs, *args, &block)
      # Make an array of attribute names
      attrs = attrs.split('_and_')

      # #transpose will zip the two arrays together like so:
      #   [[:a, :b, :c], [1, 2, 3]].transpose
      #   # => [[:a, 1], [:b, 2], [:c, 3]]
      attrs_with_args = [attrs, args].transpose

      # Hash[] will take the passed associative array and turn it
      # into a hash like so:
      #   Hash[[[:a, 2], [:b, 4]]] # => { :a => 2, :b => 4 }
      conditions = Hash[attrs_with_args]

      # #where and #all are new AREL goodness that will find all
      # records matching our conditions
      where(conditions).all
    end
  end
end

