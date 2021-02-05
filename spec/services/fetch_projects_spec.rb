require "rails_helper"

RSpec.describe FetchProjects do
  describe "#call" do

    before {
      fetch_projects_from_tenk_set_up
      fetch_team_members_from_tenk_set_up
      fetch_assignments_from_tenk_set_up
    }

    it "imports team members and projects from tenk feet" do
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

    it "recreates assignments" do
      team_member = TeamMember.create(first_name: "Jay", last_name: "Smith", tenk_id: 387517)
      old_project = Project.new(name: 'A Project', tenk_id: 404)
      team_member.assignments.create(project: old_project)
      expect(team_member.projects).to include(old_project)

      described_class.new.call

      expect(team_member.projects).not_to include(old_project)
    end

    context "when a project with that assignable_id cannot be found" do
      let(:ghost_project) { Tenk::Client::Response.new(id: nil, name: nil) }

      it "skips over that assignment" do
        fake_tenk_projects_object = double(Tenk::Projects)
        allow(fake_tenk_client).to receive(:projects).and_return(fake_tenk_projects_object)
        allow(fake_tenk_projects_object).to receive(:get)
          .with(123)
          .and_return(ghost_project)

        described_class.new.call

        team_member = TeamMember.find_by(tenk_id: 387517)
        expect(team_member.projects).to be_empty
      end
    end

    context "when optional team member attributes are nil" do
      it "creates the team member" do
        user_no_discipline = Hashie::Array[
                                Tenk::Client::Response.new(
                                  billable: true,
                                  discipline: nil,
                                  email: nil,
                                  first_name: "Tom",
                                  id: 387517,
                                  last_name: nil,
                                  thumbnail: "https://fake.thumbnail/123",
                                  type: "User",
                                )
                              ]

        allow(fake_tenk_users_object).to receive_message_chain(:list, :data)
          .and_return(user_no_discipline)

        described_class.new.call

        team_member = TeamMember.find_by(tenk_id: 387517)
        expect(team_member.discipline).to be_nil
        expect(team_member.last_name).to be_nil
        expect(team_member.email).to be_nil
      end
    end
  end

  def fake_tenk_client
    @fake_tenk_client ||= begin
      fake_tenk_client = double(Tenk::Client)
      allow(Tenk).to receive(:new).and_return(fake_tenk_client)
      fake_tenk_client
    end
  end

  def fake_tenk_users_object
    @fake_tenk_client ||= begin
      double(Tenk::Client)
    end
  end

  def fetch_projects_from_tenk_set_up
    # Stub the fetching of projects from tenk
    fake_tenk_projects_object = double(Tenk::Projects)
    allow(fake_tenk_client).to receive(:projects).and_return(fake_tenk_projects_object)
    allow(fake_tenk_projects_object).to receive(:get)
      .with(123)
      .and_return(fake_tenk_project)
  end

  def fetch_team_members_from_tenk_set_up
    # Stub the fetching of team members from tenk
    allow(fake_tenk_client).to receive(:users).and_return(fake_tenk_users_object)
    allow(fake_tenk_users_object).to receive_message_chain(:list, :data)
      .and_return(fake_team_member_response)
  end

  def fetch_assignments_from_tenk_set_up
    # Stub the fetching of assignments from tenk
    allow(fake_tenk_client).to receive(:users).and_return(fake_tenk_users_object)
    allow(fake_tenk_users_object).to receive_message_chain(:assignments, :list, :data)
      .and_return(fake_tenk_assignment_response)
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
