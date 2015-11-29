module V0Helpers
  def strip_uuid(ocd_uuid)
    ocd_uuid.split('/').last
  end

  def paginate_array(array)
    paginate(Kaminari.paginate_array(array))
  end

  def person_response(person, full_detail = false)
    return if person.nil?

    response = {
      id: strip_uuid(person.id),
      name: person.name,
      image: person.image,
    }

    if full_detail
      response.merge!({
        posts: posts_response(person.posts),
      })
    end

    response
  end

  def people_response(people, full_detail = false)
    people.map do |person|
      person_response person, full_detail
    end
  end

  def orgs_response(orgs)
    orgs.map do |org|
      org_response org
    end
  end

  def org_response(org, full_detail = false)
    return nil if org.nil?
    response = {
      id: strip_uuid(org.id),
      name: org.name,
      classification: org.classification,
      jurisdiction_id: org.jurisdiction_id,
      parent: org_response(org.parent),
    }

    if full_detail
      response.merge!(
        posts: posts_response(org.posts, true),
        children: orgs_response(org.children),
        members: people_response(org.people),
      )
    end

    return response
  end

  def bill_response(bill, full_detail = false)
    response = {
      id: strip_uuid(bill.id),
      identifier: bill.identifier,
      title: bill.title,
      classification: bill.classification,
      subject: bill.subject,
    }

    if full_detail
      response.merge!({
        legislative_session: leg_session_response(bill.legislative_session),
        votes: vote_events_response(bill.vote_events, true),
      })
    end

    response
  end

  def bills_response(bills)
    bills.map do |bill|
      bill_response bill
    end
  end

  def vote_event_response(event, full_detail = false)
    response = {
      id: strip_uuid(event.id),
      start_date: event.start_date,
      result: event.result,
      motion_text: event.motion_text,
      motion_classification: event.motion_classification,
      legislative_session: leg_session_response(event.legislative_session),
      bill: bill_response(event.bill),
      counts: vote_counts_response(event.vote_counts),
    }

    if full_detail
      response.merge!({
        roll_call: person_votes_response(event.person_votes),
      })
    end

    response
  end

  def vote_events_response(events, full_detail = false)
    events.map do |event|
      vote_event_response event, full_detail
    end
  end

  def vote_count_response(vote_count)
    {
      option: vote_count.option,
      value: vote_count.value,
    }
  end

  def vote_counts_response(vote_counts)
    vote_counts.map do |vote_count|
      vote_count_response vote_count
    end
  end

  def person_vote_response(person_vote)
    {
      vote_type: person_vote.option,
      person: person_response(person_vote.person),
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
      start_date: session.start_date,
      end_date: session.end_date,
      classification: session.classification,
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
      post: post_response(membership.post),
    }
  end

  def memberships_response(memberships)
    memberships.map do |membership|
      membership_response membership
    end
  end

  def post_response(post, full_detail = false)
    response = {
      id: strip_uuid(post.id),
      role: post.role,
    }

    if full_detail
      response.merge!(office_holders: people_response(post.people))
    end

    response
  end

  def posts_response(posts, full_detail = false)
    posts.map do |post|
      post_response post, full_detail
    end
  end

end
