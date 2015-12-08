require 'grape'

module App
  module API

    class LegislativeSessions < Grape::API
      include Grape::Kaminari
      resource :legislative_sessions do
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
            paginated = paginate_array(LegislativeSession.find(params[:id]).bills)
            bills_response paginated
          end

          get :councillors do
            paginated = paginate_array(LegislativeSession.find(params[:id]).people)
            people_response paginated
          end
        end
      end
    end

    class People < Grape::API
      include Grape::Kaminari
      resource :people do
        get do
          @people = paginate Person.all
          present @people, with: App::Entities::People
        end

        route_param :id do
          get do
            @person = Person.find_by_uuid(params[:id])
            present @person, with: App::Entities::People
          end

          get :votes do
            Person.find_by_uuid(params[:id]).person_votes.limit(20)
          end

          get :vote_events do
            Person.find_by_uuid(params[:id]).vote_events.limit(20)
          end
        end
      end

    end

    class Organizations < Grape::API
      include Grape::Kaminari
      resource :organizations do
        get do
          @organizations = Organization.all
          present @organizations, with: App::Entities::Organizations
        end

        route_param :id do
          get do
            @organization = Organization.find_by_uuid(params[:id])
            present @organization, with: App::Entities::Organizations
          end
        end
      end

    end

  end
end
