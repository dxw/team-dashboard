require 'rails_helper'

RSpec.feature 'Users can see project locations', type: 'feature' do
  context 'when a single project exist' do
    it 'will show the project location' do
      dashboard = Project.create(location: 'London')

      visit '/'
      expect(page).to have_content(dashboard.location)
    end
  end
end
