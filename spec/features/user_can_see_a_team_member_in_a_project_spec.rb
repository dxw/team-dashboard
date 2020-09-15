require 'rails_helper'

RSpec.feature 'user can see team members within a project', type: 'feature' do
  before do
    page.driver.browser.basic_authorize(ENV.fetch('HTTP_BASIC_USER'), ENV.fetch('HTTP_BASIC_PASSWORD'))
  end

  context "when the team member is assigned to only one project" do
    scenario 'they can see one team member within a given project' do
      dashboard = Project.create(name: 'Dashboard', tenk_id: 1234, ends_at: Date.today.to_s)
      member = TeamMember.create(first_name: 'Joe', last_name: "Smith", projects: [dashboard], discipline: "Development", tenk_id: 1234)

      visit '/'
      expect(page).to have_content(member.name)
      expect(page).to have_content(member.job_title)
    end
  end

  context "when the team member is assigned to more than one project" do
    scenario 'they can see themselves within multiple projects' do
      dashboard = Project.create(name: 'Dashboard', tenk_id: 1234, ends_at: Date.today.to_s)
      beis = Project.create(name: 'Beis', tenk_id: 5678, ends_at: Date.today.to_s)
      member = TeamMember.create(first_name: 'Joe', last_name: "Smith", projects: [dashboard, beis], tenk_id: 9999)

      visit '/'
      expect(page).to have_content(member.name).twice
    end
  end
end
