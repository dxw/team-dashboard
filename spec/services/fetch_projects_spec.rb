require "rails_helper"

RSpec.describe FetchProjects do
  describe "#call" do
    it "imports team members and projects from tenk feet" do
      fake_tenk_client = double(Tenk::Client)
      allow(Tenk).to receive(:new).and_return(fake_tenk_client)

      # Stub the fetching of projects from tenk
      fake_tenk_projects_object = double(Tenk::Projects)
      allow(fake_tenk_client).to receive(:projects).and_return(fake_tenk_projects_object)
      allow(fake_tenk_projects_object).to receive(:get)
        .with(123)
        .and_return(fake_tenk_project)

      # Stub the fetching of team members from tenk
      fake_tenk_users_object = double(Tenk::Client)
      allow(fake_tenk_client).to receive(:users).and_return(fake_tenk_users_object)
      allow(fake_tenk_users_object).to receive_message_chain(:list, :data)
        .and_return(fake_team_member_response)

      # Stub the fetching of assignments from tenk
      allow(fake_tenk_client).to receive(:users).and_return(fake_tenk_users_object)
      allow(fake_tenk_users_object).to receive_message_chain(:assignments, :list, :data)
        .and_return(fake_tenk_assignment_response)

      result = described_class.new.call

      # Some team members get created
      team_member = TeamMember.find_by(tenk_id: 387517)
      expect(team_member).not_to be_nil
      expect(team_member.discipline).to eql("Development")
      expect(team_member.thumbnail).to eql("https://fake.thumbnail/123")
      expect(team_member.billable).to eql(true)
      expect(team_member.first_name).to eql("Tom")
      expect(team_member.last_name).to eql("Example")

      # Some projects get created
      project = Project.find_by(tenk_id: 123)
      expect(project).not_to be_nil
      expect(project.name).to eql("Example project")
      expect(project.location).to eql(nil)
      expect(project.starts_at).to eql("2019-09-23")
      expect(project.ends_at).to eql("2020-04-01")
      expect(project.client).to eql("Fake client")
      expect(project.archived).to eql(false)

      # Team members and projects are linked together
      expect(team_member.projects).to include(project)
    end
  end

  private def fake_tenk_project
    Tenk::Client::Response.new(
      archived: false,
      archived_at: nil,
      client: "Fake client",
      created_at: "2019-02-18T22:49:32Z",
      deleted_at: nil,
      nildescription: nil,
      ends_at: "2020-04-01",
      guid: "0bd50645-f0c6-441b-9f65-14df5ca1b2f7",
      id: 123,
      name: "Example project",
      parent_id: nil,
      phase_name: nil,
      project_code: "jun-003",
      project_state: "Confirmed",
      secureurl: nil,
      secureurl_expiration: nil,
      settings: 0,
      starts_at: "2019-09-23",
      tags: Tenk::Client::Response.new(data: Hashie::Array.new([Tenk::Client::Response.new(id: 4262844, value: "I don't mind")])),
      paging: "",
      thumbnail: nil,
      timeentry_lockout: -1,
      type: "Project",
      updated_at: "2019-02-18T22:49:32Z",
      use_parent_bill_rates: false,
    )
  end

  private def fake_team_member_response
    Hashie::Array[
      Tenk::Client::Response.new(
        account_owner: false,
        archived: false,
        archived_at: nil,
        billability_target: 1.0,
        billable: true,
        billrate: -1.0,
        created_at: "2017-12-07T12:08:03Z",
        deleted: false,
        deleted_at: nil,
        discipline: "Development",
        display_name: "Tom ",
        email: "x",
        employee_number: nil,
        first_name: "Tom",
        guid: "x",
        has_login: true,
        hire_date: "x",
        id: 387517,
        invitation_pending: false,
        last_name: "Example",
        license_type: "licensed",
        location: nil,
        location_id: nil,
        login_type: "default",
        mobile_phone: nil,
        office_phone: nil,
        role: "Senior",
        termination_date: nil,
        thumbnail: "https://fake.thumbnail/123",
        type: "User",
        updated_at: "2019-11-21T13:47:28Z",
        user_settings: 590053,
        user_type_id: 7
      )
    ]
  end

  def fake_tenk_assignment_response
    Hashie::Array[
      Tenk::Client::Response.new(
        all_day_assignment: true,
        allocation_mode: "percent",
        assignable_id: 123,
        bill_rate: 135.7,
        bill_rate_id: 35112466,
        created_at: "2019-12-06T12:02:16Z",
        description: "",
        email: "x",
        ends_at: "2020-04-28",
        id: 456,
        note: "",
        percent: 1.0,
        repetition_id: nil,
        resource_request_id: nil,
        starts_at: "2020-01-22",
        status: nil,
        status_option_id: nil,
        updated_at: "2020-01-30T12:29:23Z",
        user_id: 387517,
      )
    ]
  end
end
