module V1Helpers

  def strip_uuid(ocd_uuid)
    ocd_uuid.split('/').last
  end

  def councillor_response(person)
    {
      id: strip_uuid(person.id),
      name: person.name,
      image: person.image,
    }
  end

  def councillors_response(people)
    people.map do |person|
      councillor_response person
    end
  end
end
