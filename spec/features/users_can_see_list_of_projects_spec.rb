require 'rails_helper'

RSpec.feature "Users can see a list of projects", type: "feature" do
  before do
    page.driver.browser.basic_authorize(ENV.fetch('HTTP_BASIC_USER'), ENV.fetch('HTTP_BASIC_PASSWORD'))
  end

  context "when a single active project exists" do
    it "will show a list of projects on the main page" do
      dashboard = Project.create(name: "Dashboard", tenk_id: 1234, ends_at: Date.today.to_s)
      member = TeamMember.create(first_name: 'Joe', last_name: "Smith", projects: [dashboard], tenk_id: 1234)

      visit "/"
      expect(page).to have_content(dashboard.name)
    end
  end

  context "when an inactive project exists" do
    it "will not be displayed on the main page" do
      active_project = Project.create(name: "Dashboard", tenk_id: 1234, ends_at: Date.today.to_s)
      inactive_project = Project.create(name: "Old Project", tenk_id: 5678, ends_at: Date.yesterday.to_s)
      member = TeamMember.create(first_name: 'Joe', last_name: "Smith", projects: [active_project, inactive_project], tenk_id: 1234)

      visit "/"
      expect(page).to have_content(active_project.name)
      expect(page).not_to have_content(inactive_project.name)
    end
  end

end
