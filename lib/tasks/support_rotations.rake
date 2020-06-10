require 'dotenv/tasks'
require 'support_rotations_fetcher'

namespace :support_rotations do
  task fetch_first_line: [:dotenv, :environment] do
    # Fetch raw support rotation data from OpsGenie
    support_timelines = FirstLineRotationsFetcher.new.call

    # Each support "stream", such as "OOH", "Dev from [date]", etc represents one timeline
    support_timelines.each do |timeline|
      support_type = SupportRotationsFetcher.detect_stream(timeline.name)
      puts "\n Processing #{timeline.name} timeline as #{support_type}..."

      support_periods = SupportRotationsFetcher.assigned(timeline.periods)
      puts "\t Processing #{support_periods.size} periods..."

      support_periods.each do |period|
        # OpsGenie periods are 8 hour intervals
        # They _can_ span two calendar days for OOH,
        # but we only need the day the period starts
        date = period.start_date.to_date

        email = period.user.username
        team_member = TeamMember.find_by(email: email)

        if team_member.nil?
          puts "\t Could not find #{email}"
          next
        end

        puts "\t Creating support day for #{team_member.first_name} on #{date}"

        support_day = SupportDay.find_or_initialize_by(
          team_member_id: team_member.id,
          date: date,
          support_type: support_type
        )
        support_day.save!
      end
    end
  end
end
