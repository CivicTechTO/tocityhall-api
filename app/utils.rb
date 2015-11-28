TORONTO_COUNCIL_ORG_ID = 'ocd-organization/d151a57c-2600-4c3a-808a-863436e338ff'
TORONTO_COUNCIL_JUR_ID = 'ocd-jurisdiction/country:ca/csd:3520005/legislature'
TORONTO_DISTRICT_ID = 'ocd-division/country:ca/csd:3520005'

module PrettyJSON
  def self.call(object, env)
    JSON.pretty_generate(JSON.parse(object.to_json))
  end
end

