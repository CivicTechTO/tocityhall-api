module V1Helpers

  def strip_uuid(ocd_uuid)
    ocd_uuid.split('/').last
  end

  def councillor_response(person)
    {
      id: strip_uuid(person.id),
      name: person.name,
      image: person.image,
    } unless person.nil?
  end

  def councillors_response(people)
    people.map do |person|
      councillor_response person
    end
  end

  def bill_response(bill)
    {
      id: strip_uuid(bill.id),
      identifier: bill.identifier,
      title: bill.title,
      legislative_session: leg_session_response(bill.legislative_session)
    }
  end

  def bills_response(bills)
    bills.map do |bill|
      bill_response bill
    end
  end

  def vote_event_response(event)
    {
      id: strip_uuid(event.id),
      date: event.start_date,
      result: event.result,
      motion_text: event.motion_text,
      motion_classification: event.motion_classification,
      legislative_session: leg_session_response(event.legislative_session),
    }
  end

  def vote_events_response(events)
    events.map do |event|
      vote_event_response event
    end
  end

  def person_vote_response(person_vote)
    {
      id: person_vote.id,
      option: person_vote.option,
      voter: councillor_response(person_vote.person),
    }
  end

  def person_votes_response(person_votes)
    person_votes.map do |person_vote|
      person_vote_response person_vote
    end
  end

  def leg_session_response(leg_session)
    {
      id: leg_session.id,
      name: leg_session.name,
    }
  end

end
