module V0Helpers
  def strip_uuid(ocd_uuid)
    ocd_uuid.split('/').last
  end

  def paginate_array(array)
    paginate(Kaminari.paginate_array(array))
  end

  def person_response(person, full_detail = false)
    return if person.nil?

    keys_to_filter = [
      person.class.model_name.plural,
      person.class.model_name.singular,
    ]

    response = {
      id: strip_uuid(person.id),
      name: person.name,
      image: person.image,
      posts: posts_response(person.posts, keys_to_filter),
      memberships: memberships_response(person.memberships, keys_to_filter),
    }

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

  def membership_response(membership, filter = [])
    response = {
      id: strip_uuid(membership.id),
      role: membership.role,
      start_date: membership.start_date,
      end_date: membership.end_date,
      #post: post_response(membership.post),
      #organization: org_response(membership.organization),
      person: person_response(membership.person),
    }

    filter.each { |k| response.delete! k }


    if full_detail
      response.merge!(person: person_response(membership.person))
    end

    return response

  end

  def memberships_response(memberships, filter = [])
    memberships.map do |membership|
      membership_response membership, filter
    end
  end

  def post_response(post, filter = [])
    response = {
      id: strip_uuid(post.id),
      role: post.role,
      people: people_response(post.people),
    }

    filter.each { |k| response.delete! k }

    response
  end

  def posts_response(posts, filter = [])
    posts.map do |post|
      post_response post, filter
    end
  end

end
