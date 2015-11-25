module V0Helpers
  def strip_uuid(ocd_uuid)
    ocd_uuid.split('/').last
  end

  def paginate_array(array)
    paginate(Kaminari.paginate_array(array))
  end

  def person_response(person)
    {
      id: strip_uuid(person.id),
      name: person.name,
      image: person.image,
    } unless person.nil?
  end

  def people_response(people)
    people.map do |person|
      person_response person
    end
  end

  def bill_response(bill, full_detail = false)
    {
      id: strip_uuid(bill.id),
      identifier: bill.identifier,
      title: bill.title,
      legislative_session: leg_session_response(bill.legislative_session),
      vote_events: vote_events_response(bill.vote_events, full_detail),
    }
  end

  def bills_response(bills)
    bills.map do |bill|
      bill_response bill
    end
  end

  def vote_event_response(event, full_detail = false)
    vote_event = {
      id: strip_uuid(event.id),
      date: event.start_date,
      result: event.result,
      motion_text: event.motion_text,
      motion_classification: event.motion_classification,
      legislative_session: leg_session_response(event.legislative_session),
    }

    if full_detail
      vote_event.merge!(votes: person_votes_response(event.person_votes))
    end

    vote_event
  end

  def vote_events_response(events, full_detail = false)
    events.map do |event|
      vote_event_response event, full_detail
    end
  end

  def person_vote_response(person_vote)
    {
      option: person_vote.option,
      councillor: person_response(person_vote.person),
    }
  end

  def person_votes_response(person_votes)
    person_votes.map do |person_vote|
      person_vote_response person_vote
    end
  end

  def leg_session_response(session)
    {
      id: session.id,
      name: session.name,
      jurisdiction_id: session.jurisdiction_id,
    }
  end

  def leg_sessions_response(sessions)
    sessions.map do |session|
      leg_session_response session
    end
  end

  def membership_response(membership)
    {
      id: strip_uuid(membership.id),
      role: membership.role,
      person: person_response(membership.person),
      post: membership.post,
    }
  end

  def memberships_response(memberships)
    memberships.map do |membership|
      membership_response membership
    end
  end

end
