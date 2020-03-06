require 'rails_helper'

RSpec.feature "Users can see a list of projects", type: "feature" do

  context "when a single project exist" do
    it "will show a list of projects on the main page" do
      dashboard = Project.create(name: "Dashboard")
      member = TeamMember.create(name: 'Joe', project: dashboard, tenk_id: 1234)

      visit '/'
      expect(page).to have_content(dashboard.name)
    end
  end

end
