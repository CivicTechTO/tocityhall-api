class ApiV1 < Grape::API
  version 'v1', using: :path
  format :json
  helpers V1Helpers
  formatter :json, PrettyJSON

  include Grape::Kaminari

  paginate per_page: 20, max_per_page: 100, offset: false

  get :councillors do
    people = councillors_response Person.all

    paginate(Kaminari.paginate_array(people))
  end

  namespace :councillors do
    route_param :id do
      get do
        councillor_response Person.find("ocd-person/#{params[:id]}")
      end

      get :votes do
        Person.find("ocd-person/#{params[:id]}").person_votes.limit(20)
      end

      get :vote_events do
        Person.find("ocd-person/#{params[:id]}").vote_events.limit(20)
      end
    end
  end

  get :vote_events do
    VoteEvent.limit(20)
  end

  namespace :vote_events do
    route_param :id do
      get do
        VoteEvent.find(params[:id])
      end

      get :votes do
        VoteEvent.find(params[:id]).person_votes.limit(20)
      end

      get :councillors do
        VoteEvent.find(params[:id]).people.limit(20)
      end
    end
  end

  get :bills do
    Bill.where(from_organization_id: TORONTO_COUNCIL_ORG_ID).limit(20)
  end

  namespace :bills do
    route_param :id do
      get do
        Bill.find(params[:id])
      end

      get :vote_events do
        Bill.find(params[:id]).vote_events.limit(20)
      end

      get :councillors do
        Bill.find(params[:id]).people.limit(20)
      end

      get :votes do
        Bill.find(params[:id]).person_votes.limit(20)
      end
    end
  end

  get :sessions do
    LegislativeSession.where(jurisdiction_id: TORONTO_COUNCIL_JUR_ID).limit(20)
  end

  namespace :sessions do
    route_param :id do
      get do
        LegislativeSession.find(params[:id])
      end

      get :bills do
        LegislativeSession.find(params[:id]).bills.limit(20)
      end
    end
  end

end
