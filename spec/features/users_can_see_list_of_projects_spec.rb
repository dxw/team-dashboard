require 'rails_helper'

RSpec.feature "Users can see a list of projects", type: "feature" do
  before do
    page.driver.browser.basic_authorize(ENV.fetch('HTTP_BASIC_USER'), ENV.fetch('HTTP_BASIC_PASSWORD'))
  end

  context "when a single project exist" do
    it "will show a list of projects on the main page" do
      dashboard = Project.create(name: "Dashboard", tenk_id: 1234)
      member = TeamMember.create(first_name: 'Joe', last_name: "Smith", project: dashboard, tenk_id: 1234)

      visit '/'
      expect(page).to have_content(dashboard.name)
    end
  end

end
