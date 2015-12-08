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

    class Events < Grape::API
      include Grape::Kaminari
      resource :events do
        get do
          @events = paginate Event.all
          present @events
        end

        route_param :id do
          get do
            Event.find_by_uuid(params[:id])
          end
        end
      end

    end

    class Posts < Grape::API
      include Grape::Kaminari
      resource :posts do
        get do
          @posts = paginate Post.all
          present @posts
        end

        route_param :id do
          get do
            @post = Post.find_by_uuid(params[:id])
            present @post
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

    class Memberships < Grape::API
      include Grape::Kaminari
      resource :memberships do
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
      resource :bills do
        get do
          @bills = paginate Bill.all
          present @bills
        end

        route_param :id do
          get do
            @bill = Bill.find_by_uuid(params[:id])
            present @bill
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

    class Votes < Grape::API
      include Grape::Kaminari
      resource :votes do
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
