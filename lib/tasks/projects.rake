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

    users = tenk.users.list(per_page: 100).data

    users.each do |user|
      puts user
      team_member = TeamMember.find_or_initialize_by(tenk_id: user.id)

      team_member.attributes = {
        first_name: user.first_name,
        last_name: user.last_name,
        discipline: user.discipline,
        thumbnail: user.thumbnail,
        billable: user.billable
      }

      assignments = tenk.users.assignments.list(
        user.id,
        from: Date.yesterday,
        to: Date.tomorrow,
      ).data

      assignments.each do |assignment|

        assignable_project = projects[assignment.assignable_id]
        puts " #{projects[assignment.assignable_id].tags};"

        puts assignment.assignable_id
        puts assignable_project
        while assignable_project.parent_id
          puts "#{assignable_project.name} (#{assignable_project.id}), phase of #{assignable_project.parent_id}"
          assignable_project = projects[assignable_project.parent_id]
        end

        if assignable_project.name
          unless assignable_project.tags.data.any? { |custom_field| custom_field.has_value?("cyber")  }
            project = Project.find_or_initialize_by(tenk_id: assignable_project.id)

            project.attributes = {
              name: assignable_project.name,
              starts_at: assignable_project.starts_at,
              ends_at: assignable_project.ends_at,
              client: assignable_project.client,
              archived: assignable_project.archived
            }
            project.save!

            team_member.projects << project unless team_member.projects.include?(project)
          end
        end
      end

      team_member.save!

    end
  end
end
