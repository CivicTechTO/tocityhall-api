require 'grape'
require 'grape-swagger'
require_relative 'entities'

module App
  module API

    class LegislativeSessions < Grape::API
      include Grape::Kaminari
      desc = { desc: 'Four-Year legislative terms of governance' }
      resource :legislative_sessions, desc do
        get do
          @sessions = paginate LegislativeSession.all
          present @sessions, with: App::Entities::LegislativeSessions
        end

        route_param :id do
          get do
            @session = LegislativeSession.find(params[:id])
            present @session, with: App::Entities::LegislativeSessions
          end

          get :bills do
            @session_bills = paginate LegislativeSession.find(params[:id]).bills
            present @session_bills
          end

          get :people do
            @session_people = paginate LegislativeSession.find(params[:id]).people
            present @session_people
          end
        end
      end
    end

    class Events < Grape::API
      include Grape::Kaminari
      desc = { desc: 'Meetings of organizations or persons' }
      resource :events, desc do

        desc 'Get all events', entity: App::Entities::Events
        get do
          @events = paginate Event.all
          present @events, with: App::Entities::Events
        end

        params do
          requires :id, {
            type: String,
            desc: 'Event UUID',
            documentation: {
              example: ENV['TOCITYHALL_EXAMPLE_UUID_EVENT'],
            }
          }
        end
        route_param :id do
          desc 'Get a single event', entity: App::Entities::Events
          get do
            @event = Event.find_by_uuid(params[:id])
            present @event, with: App::Entities::Events
          end
        end
      end

    end

    class Locations < Grape::API
      include Grape::Kaminari
      desc = { desc: 'Locations of meetings' }
      resource :locations, desc do
        get do
          @locations = paginate Location.all
          present @locations
        end
      end
    end

    class Posts < Grape::API
      include Grape::Kaminari
      desc = { desc: 'Positions within organizations' }
      resource :posts, desc do
        get do
          @posts = paginate Post.all
          present @posts, with: App::Entities::Posts
        end

        route_param :id do
          get do
            @post = Post.find_by_uuid(params[:id])
            present @post, with: App::Entities::Posts
          end
        end
      end

    end

    class People < Grape::API
      include Grape::Kaminari
      desc = { desc: 'Mayors, councillors and public/private appointees' }
      resource :people, desc do

        desc 'Get all people', entity: App::Entities::People
        get do
          @people = paginate Person.all
          present @people, with: App::Entities::People
        end

        params do
          requires :id, {
            type: String,
            desc: 'Person UUID',
            documentation: {
              example: ENV['TOCITYHALL_EXAMPLE_UUID_PERSON'],
            }
          }
        end
        route_param :id do
          desc 'Get a single person', entity: App::Entities::People
          get do
            @person = Person.find_by_uuid(params[:id])
            present @person, with: App::Entities::People
          end

          desc "Get a single person's votes"
          get :votes do
            Person.find_by_uuid(params[:id]).vote_events.limit(20)
          end

          desc "Get a single person's organizations", entity: App::Entities::Organizations
          get :organizations do
            @organizations = paginate Person.find_by_uuid(params[:id]).organizations
            present @organizations, with: App::Entities::Organizations
          end

          desc "Get a single person's memberships", entity: App::Entities::Memberships
          get :memberships do
            @memberships = paginate Person.find_by_uuid(params[:id]).memberships
            present @memberships
          end
        end
      end

    end

    class Memberships < Grape::API
      include Grape::Kaminari
      desc = { desc: 'Elected or appointed terms at organizations' }
      resource :memberships, desc do
        get do
          @memberships = paginate Membership.all
          present @memberships
        end

        route_param :id do
          get do
            @member = Membership.find_by_uuid(params[:id])
            present @member
          end
        end
      end
    end

    class Bills < Grape::API
      include Grape::Kaminari
      desc = { desc: 'Bylaws voted into law by organizations' }
      resource :bills, desc do
        desc 'Get all bills', entity: App::Entities::Bills
        get do
          @bills = paginate Bill.all
          present @bills, with: App::Entities::Bills
        end

        params do
          requires :id, {
            type: String,
            desc: 'Bill UUID',
            documentation: {
              example: ENV['TOCITYHALL_EXAMPLE_UUID_BILL'],
            }
          }
        end
        route_param :id do
          desc 'Get a single bill', entity: App::Entities::Bills
          get do
            @bill = Bill.find_by_uuid(params[:id])
            present @bill, with: App::Entities::Bills
          end

          get :vote_events do
            Bill.find_by_uuid(params[:id]).vote_events.limit(20)
          end

          get :councillors do
            Bill.find_by_uuid(params[:id]).people.limit(20)
          end

          get :votes do
            Bill.find_by_uuid(params[:id]).person_votes.limit(20)
          end
        end
      end
    end

    class Organizations < Grape::API
      include Grape::Kaminari
      model = :organization

      desc = { desc: 'Committees, boards, agencies, and corporations' }
      resource :organizations, desc do

        desc 'Get all organizations', entity: App::Entities::Organizations
        get do
          @organizations = Organization.all
          present @organizations, with: App::Entities::Organizations
        end

        params do
          requires :id, {
            type: String,
            desc: 'Organization UUID',
            documentation: {
              example: ENV['TOCITYHALL_EXAMPLE_UUID_ORG'],
            }
          }
        end
        route_param :id do
          desc 'Get a single organization', entity: App::Entities::Organizations
          get do
            @organization = Organization.find_by_uuid(params[:id])
            present @organization, with: App::Entities::FullOrganizations, root_model: model
          end

          desc "Get a single organization's people", entity: App::Entities::People
          get :people do
            @people = paginate Organization.find_by_uuid(params[:id]).people
            present @people, with: App::Entities::People
          end

          desc "Get a single organization's events", entity: App::Entities::Events
          get :events do
            @events = paginate Organization.find_by_uuid(params[:id]).events
            present @events, with: App::Entities::Events, root_model: model
          end
        end
      end

    end

    class Votes < Grape::API
      include Grape::Kaminari
      desc = { desc: 'Vote event on which a individual vote was held' }
      resource :votes, desc do
        get do
          @votes = paginate VoteEvent.all
          present @votes
        end

        route_param :id do
          get do
            @vote = VoteEvent.find_by_uuid(params[:id])
            present @vote
          end

          get :votes do
            person_votes = VoteEvent.find_by_uuid(params[:id]).person_votes
            paginated = paginate_array(person_votes)

            person_votes_response paginated
          end

          get :councillors do
            people = VoteEvent.find_by_uuid(params[:id]).people
            paginated = paginate_array(people)

            people_response paginated
          end
        end
      end
    end

  end
end
