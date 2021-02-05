require 'rails_helper'

RSpec.feature "Users can see the table of support rotations", type: "feature" do
  before do
    page.driver.browser.basic_authorize(ENV.fetch('HTTP_BASIC_USER'), ENV.fetch('HTTP_BASIC_PASSWORD'))
  end

  it "will show the people assigned to support rotations and the affected client projects" do
    support_project = Project.create(name: "1st line support", tenk_id: ENV.fetch("TENK_ID_FOR_SUPPORT", nil))
    client1 = Project.create(name: "Client One", tenk_id: 123, starts_at: 1.month.ago, ends_at: Date.today.to_s)
    team_member = TeamMember.create(first_name: "Jay", projects: [client1, support_project], tenk_id: 1234)

    past_day = team_member.support_days.create(date: 1.month.ago, support_type: "dev")
    current_day = team_member.support_days.create(date: Date.today, support_type: "dev")
    future_day = team_member.support_days.create(date: 2.months.from_now, support_type: "dev")

    dev_day = team_member.support_days.create(date: 2.months.from_now, support_type: "dev")
    ops_day = team_member.support_days.create(date: 2.months.from_now, support_type: "ops")
    ooh1_day = team_member.support_days.create(date: 2.months.from_now, support_type: "ooh1")
    ooh2_day = team_member.support_days.create(date: 2.months.from_now, support_type: "ooh2")

    visit "/support_rotations"

    expect(page).to have_content("Support rotations")
    expect(page).to have_content("Client One")
    expect(page).not_to have_content("1st line support")
  end
end
