class ApiV0 < Grape::API
  version 'v0', using: :path
  format :json
  helpers V0Helpers
  formatter :json, PrettyJSON

  include Grape::Kaminari

  paginate per_page: 20, max_per_page: 100, offset: false

  namespace :councillors do
    get do
      paginated = paginate_array(Person.all)
      people_response(paginated)
    end

    route_param :id do
      get do
        person_response Person.find_by_uuid(params[:id])
      end

      get :votes do
        Person.find_by_uuid(params[:id]).person_votes.limit(20)
      end

      get :vote_events do
        Person.find_by_uuid(params[:id]).vote_events.limit(20)
      end
    end
  end

  namespace :vote_events do
    get do
      paginated = paginate_array(VoteEvent.all)
      vote_events_response(paginated)
    end

    route_param :id do
      get do
        vote_event_response VoteEvent.find_by_uuid(params[:id])
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

  namespace :bills do
    get do
      paginated = paginate_array(Bill.in_toronto)
      bills_response paginated
    end

    route_param :id do
      get do
        bill_response Bill.find_by_uuid(params[:id]), true
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

  namespace :legislative_sessions do
    get do
      paginated = paginate_array(LegislativeSession.in_toronto)
      leg_sessions_response paginated
    end

    route_param :id do
      get do
        LegislativeSession.find(params[:id])
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

  namespace :memberships do
    get do
      paginated = paginate_array(Membership.all)
      memberships_response(paginated)
    end
  end

  namespace :posts do
    get do
      Post.all
    end
  end

end
