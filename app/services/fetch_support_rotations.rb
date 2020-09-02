require 'support_rota_client'

class FetchSupportRotations
  def initialize(client: SupportRotaClient.new)
    @client = client
  end

  attr_accessor :client

  def call
    SupportDay::DXW_SUPPORT_TYPES.each do |support_type|
      json_endpoint = "/v2/#{support_type}/rota.json"

      support_data = JSON.parse(client.get(json_endpoint))
      support_data.each do |support_datum|
        date = Date.parse(support_datum.fetch("date"))
        email = support_datum.dig("person", "email")

        next if email.blank?

        puts "Processing #{date} featuring #{email}..."

        team_member = TeamMember.find_by(email: email)

        if team_member.nil?
          puts "\t Could not find #{email}"
          next
        end

        SupportDay.find_or_initialize_by(
          team_member_id: team_member.id,
          date: date,
          support_type: support_type
        ).save!
      end
    end
  end
end
