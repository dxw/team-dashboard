require 'dotenv/tasks'

namespace :projects do
  desc 'Fetch a list of users and their projects from 10,000ft'
  task fetch: [:dotenv, :environment] do
    tenk = Tenk.new(
      user_id: ENV.fetch('TENK_USER_ID'),
      password: ENV.fetch('TENK_PASSWORD'),
    )

    projects = Hash.new { |hash, project_id|
      hash[project_id] = tenk.projects.get(project_id)
    }

    users = tenk.users.list.data

    users.each do |user|
      team_member = TeamMember.create!(name: user.first_name + " " + user.last_name, tenk_id: user.id)
      puts team_member

      assignments = tenk.users.assignments.list(
        user.id,
        from: Date.yesterday,
        to: Date.tomorrow,
      ).data

      assignments.each do |assignment|
        puts "  #{projects[assignment.assignable_id].name};"
      end
    end
  end
end
