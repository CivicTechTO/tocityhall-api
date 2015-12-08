require 'grape'

module App
  module Entities
    class People < Grape::Entity
      expose :id
      expose :name
      expose :image
    end

    class Organizations < Grape::Entity
      expose :id
      expose :name
      expose :classification
      expose :jurisdiction_id
      expose :parent, if: lambda {|org, options| options[:type] != :children} do |org, options|
        App::Entities::Organizations.represent org.parent, options.merge(type: :parent)
      end
      expose :children, if: lambda {|org, options| options[:type] != :parent} do |org, options|
        App::Entities::Organizations.represent org.children, options.merge(type: :children)
      end
    end

  end
end
