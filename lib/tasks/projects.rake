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
        puts " #{projects[assignment.assignable_id].tags};"


        if projects[assignment.assignable_id].name
          unless projects[assignment.assignable_id].tags.data.any? { |custom_field| custom_field.has_value?("cyber")  }
            project = Project.find_or_create_by!(
              name: projects[assignment.assignable_id].name,
              starts_at: projects[assignment.assignable_id].starts_at,
              ends_at: projects[assignment.assignable_id].ends_at,
              client: projects[assignment.assignable_id].client,
              phase_name: projects[assignment.assignable_id].phase_name,
              archived: projects[assignment.assignable_id].archived
              )
            team_member.project = project

          end
        end
      end

      team_member.save!

    end
  end
end
