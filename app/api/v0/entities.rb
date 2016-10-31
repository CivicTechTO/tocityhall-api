require 'grape'

module App
  module Entities

    ORG_RELATION_DOCS = {
      desc: 'Organizations',
      param_type: 'body',
      is_array: true,
    }

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
      expose :name, documentation: {type: String, desc: 'A primary name, e.g. a legally recognized name'}
      expose :classification, documentation: {type: String, desc: 'An organization category, e.g. committee'}
      expose :jurisdiction_id, documentation: {type: String}
      # TODO: Figure out docs for this (broken)
      expose :parent, unless: is_child, documentation: ORG_RELATION_DOCS.merge(is_array:false) do |org, options|
        App::Entities::Organizations.represent org.parent, options.merge(type: :parent)
      end
      expose :children, unless: is_parent, documentation: ORG_RELATION_DOCS do |org, options|
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
      # TODO: Fix. Docs only work with 'using' key, which doesn't fit here...
      expose :organizations, documentation: ORG_RELATION_DOCS do |instance, options|
        if options[:collection]
          Organizations.represent instance.organizations, only: [:id, :name]
        else
          MinimalOrgs.represent instance.organizations
        end
      end
      expose :memberships, unless: :collection, using: Memberships
      expose :division do |instance|
        instance.posts.joins(:organization).find_by("opencivicdata_organization.name = 'Toronto City Council'").division
      end
    end

    class MinimalPeople < People
      unexpose :organizations
    end

    class Posts < Grape::Entity
      expose :id do |instance| instance.id.split('/').last end
      expose :label, :role, :start_date, :end_date, :organization_id, :extras
      expose :division

      expose :people

      expose :created_at, :updated_at
    end

    class Locations < Grape::Entity
      expose :name
      expose :url
    end

    class EventRelatedEntities < Grape::Entity
      expose :name, :entity_type, :bill_id
      expose :link do |instance|
        if instance.bill
          instance.bill.bill_documents[0].bill_document_links[0].url
        end
      end
    end

    class AgendaItems < Grape::Entity
      expose :order
      expose :description
      expose :subjects
      expose :classification
      expose :event_related_entities, as: :related_entities, using: EventRelatedEntities
    end

    class EventParticipants < Grape::Entity
      expose :name, :entity_type, :organization_id, :person_id
    end

    class Events < Grape::Entity
      expose :id do |instance| instance.id.split('/').last end
      expose :name, :description, :start_time, :end_time, :status
      expose :location do |instance| instance.location.name end
      expose :agenda_items, as: :agenda, using: AgendaItems
      expose :participants do
        expose :organizations, using: MinimalOrgs
      end
    end

    class AgendaItems < Grape::Entity
      expose :id, :description, :order, :subjects, :notes
      expose :event
    end

    class FullOrganizations < Organizations
      expose :people, using: MinimalPeople
      expose :events, using: Events
    end

    class Bills < Grape::Entity
      expose :id, :identifier, :title, :from_organization_id, :legislative_session_id
      expose :organization
      expose :vote_events
    end

  end
end
