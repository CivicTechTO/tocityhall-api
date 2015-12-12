require 'grape'

module App
  module Entities

    class LegislativeSessions < Grape::Entity
      expose :id
      expose :name
      expose :start_date
      expose :end_date
      expose :jurisdiction_id
      expose :classification
    end

    class Organizations < Grape::Entity
      is_child = lambda {|instance, options| options[:type] == :child}
      is_parent = lambda {|instance, options| options[:type] == :parent}

      expose :id do |instance| instance.id.split('/').last end
      expose :name
      expose :classification
      expose :jurisdiction_id
      expose :parent, unless: is_child do |org, options|
        App::Entities::Organizations.represent org.parent, options.merge(type: :parent)
      end
      expose :children, unless: is_parent do |org, options|
        App::Entities::Organizations.represent org.children, options.merge(type: :child)
      end
    end

    class MinimalOrgs < Organizations
      unexpose :parent
      unexpose :children
    end

    class Memberships < Grape::Entity
      expose :id do |instance| instance.id.split('/').last end
      expose :role, :start_date, :end_date, :post_id
      expose :organization do |instance|
        Organizations.represent instance.organization, only: [:id, :name]
      end
    end

    class People < Grape::Entity
      expose :id do |instance| instance.id.split('/').last end
      expose :name, documentation: {type: 'string', desc: 'A person’s preferred full name'}
      expose :image, documentation: {type: 'string', desc: 'A URL of a head shot'}
      expose :organizations do |instance, options|
        if options[:collection]
          Organizations.represent instance.organizations, only: [:id, :name]
        else
          MinimalOrgs.represent instance.organizations
        end
      end
      expose :memberships, unless: :collection, using: Memberships
    end

    class MinimalPeople < People
      unexpose :organizations
    end

    class Posts < Grape::Entity
      expose :id do |instance| instance.id.split('/').last end
      expose :role
      expose :people
    end

    class Locations < Grape::Entity
      expose :name
      expose :url
    end

    class AgendaItems < Grape::Entity
      expose :order
      expose :description
    end

    class EventParticipants < Grape::Entity
      expose :name, :entity_type, :organization_id, :person_id
    end

    class Events < Grape::Entity
      expose :id do |instance| instance.id.split('/').last end
      expose :name, :description, :start_time, :end_time, :status
      expose :location do |instance| instance.location.name end
      expose :agenda_items, as: :agenda, using: AgendaItems
      expose :organizations, unless: { root_model: :organization }, using: MinimalOrgs
    end

    class FullOrganizations < Organizations
      expose :people, using: MinimalPeople
      expose :events, using: Events
    end

  end
end
