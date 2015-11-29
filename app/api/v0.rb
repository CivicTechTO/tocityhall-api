class ApiV0 < Grape::API
  version 'v0', using: :path
  format :json
  helpers V0Helpers
  formatter :json, PrettyJSON

  include Grape::Kaminari

  paginate per_page: 20, max_per_page: 100, offset: false

  # No need to implement while we're just working on Toronto.
  # namespace :divisions
  # namespace :jurisdictions

  namespace :organizations do
    get do
      orgs_response paginate_array(Organization.all)
    end

    route_param :id do
      get do
        org_response(Organization.find_by_uuid(params[:id]), true)
      end
    end
  end

  namespace :legislative_sessions do
    get do
      paginated = paginate_array(LegislativeSession.all)
      leg_sessions_response paginated
    end

    route_param :id do
      get do
        leg_session_response LegislativeSession.find(params[:id])
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

  namespace :events do
    get do
      paginate_array(Event.all)
    end

    route_param :id do
      get do
        Event.find_by_uuid(params[:id])
      end
    end
  end

  namespace :posts do
    get do
      paginated = paginate_array(Post.all)
      posts_response(paginated)
    end

    route_param :id do
      get do
        post_response Post.find_by_uuid(params[:id])
      end
    end
  end

  namespace :memberships do
    get do
      paginated = paginate_array(Membership.all)
      memberships_response(paginated)
    end

    route_param :id do
      get do
        membership_response Membership.find_by_uuid(params[:id])
      end
    end
  end

  namespace :councillors do
    get do
      paginated = paginate_array(Person.all)
      people_response(paginated)
    end

    route_param :id do
      get do
        person_response Person.find_by_uuid(params[:id]), true
      end

      get :votes do
        Person.find_by_uuid(params[:id]).person_votes.limit(20)
      end

      get :vote_events do
        Person.find_by_uuid(params[:id]).vote_events.limit(20)
      end
    end
  end

  namespace :bills do
    get do
      paginated = paginate_array(Bill.all)
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

  namespace :votes do
    get do
      paginated = paginate_array(VoteEvent.all)
      vote_events_response(paginated)
    end

    route_param :id do
      get do
        vote_event_response VoteEvent.find_by_uuid(params[:id]), true
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
