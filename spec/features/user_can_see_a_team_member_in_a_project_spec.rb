require 'rails_helper'

RSpec.feature 'user can see team members within a project', type: 'feature' do
  before do
    page.driver.browser.basic_authorize(ENV.fetch('HTTP_BASIC_USER'), ENV.fetch('HTTP_BASIC_PASSWORD'))
  end

  scenario 'they can see one team member within a given project' do
    dashboard = Project.create(name: 'Dashboard', tenk_id: 1234)
    member = TeamMember.create(first_name: 'Joe', last_name: "Smith", project: dashboard, tenk_id: 1234)

    visit '/'
    expect(page).to have_content(member.name)
  end
end
