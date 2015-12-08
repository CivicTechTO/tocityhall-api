require 'grape'

module App
  module API
    class People < Grape::API
      resource :people do
        get do
          @people = Person.all
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
