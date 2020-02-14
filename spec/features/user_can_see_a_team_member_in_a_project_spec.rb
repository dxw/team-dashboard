require 'rails_helper'

RSpec.feature 'user can see team members within a project', type: 'feature' do
  scenario 'they can see one team member within a given project' do
    dashboard = Project.create(name: 'Dashboard')
    member = TeamMember.create(name: 'Joe', project: dashboard)

    visit '/'
    expect(page).to have_content(member.name)
  end
end
