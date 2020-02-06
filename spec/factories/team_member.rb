FactoryBot.define do

  factory :team_member do
    name "Joe"
    role "Developer"
    association :project
  end
  
end
