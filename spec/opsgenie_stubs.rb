def stub_schedule
  id = SupportRotationsFetcher::OPSGENIE_SCHEDULE_ID
  url = "https://api.opsgenie.com/v2/schedules/#{id}?identifierType=id"
  body = JSON.parse(File.read(File.join("spec", "fixtures", "schedule.json"))).to_json
  stub_request(:get, url)
    .to_return(
      status: 200,
      body: body,
      headers: {
        "Content-Type" => "application/json"
      }
    )
end

def stub_support_rotations(date: Date.today, fixture_name: "support_rotations")
  url = Regexp.new("https://api.opsgenie.com/v2/schedules/[a-z0-9-]+/timeline[.]*")
  body = JSON.parse(File.read(File.join("spec", "fixtures", "#{fixture_name}.json"))).to_json
  stub_request(:get, url)
    .to_return(
      status: 200,
      body: body,
      headers: {
        "Content-Type" => "application/json"
      }
    )
end

def stub_opsgenie_users
  url = "https://api.opsgenie.com/v2/users?limit=500"
  body = JSON.parse(File.read(File.join("spec", "fixtures", "opsgenie_users.json"))).to_json
  stub_request(:get, url)
    .to_return(
      status: 200,
      body: body,
      headers: {
        "Content-Type" => "application/json"
      }
    )
end
