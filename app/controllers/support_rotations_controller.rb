class SupportRotationsController < ApplicationController
  def index
    support_days = SupportDay.current

    # Group into week-aspirational intervals
    combined_days = team_support_days(support_days)
    batched_days = batched_team_support_days(combined_days)
    sorted_intervals = create_intervals(batched_days).sort_by(&:start_date)

    # Group by calendar week
    @intervals = sorted_intervals.group_by(&:calendar_week)
  end

  private

  def create_intervals(batched_days)
    batched_days.map { |batch| create_interval(batch) }
  end

  def create_interval(batch)
    first_day = batch.first
    last_day = batch.last

    start_date = first_day.day
    end_date = last_day.day

    ooh = first_day.ooh_person
    ops = first_day.ops_eng
    dev = first_day.developer

    Interval.new(start_date: start_date,
                 end_date: end_date,
                 first_line_dev: dev,
                 first_line_ops: ops,
                 first_line_ooh: ooh)
  end

  Interval = Struct.new(:start_date, :end_date, :first_line_dev, :first_line_ops, :first_line_ooh, keyword_init: true) {
    def calendar_week
      start_date.cweek
    end

    def developer_name
      first_line_dev.name
    end

    def ooh_person_name
      first_line_ooh.name
    end

    def ops_eng_name
      first_line_ops.name
    end

    def affected_projects
      in_hours_projects = (first_line_dev.projects + first_line_ops.projects).uniq
      client_projects = in_hours_projects.select { |p| p.tenk_id != Project::TENKFT_ID_FOR_SUPPORT }
      client_projects.select do |project|
        start_date <= Date.parse(project.ends_at) &&
          end_date >= Date.parse(project.starts_at)
      end.map(&:name).join(", ")
    end
  }

  def team_support_days(support_days)
    support_days.group_by(&:date).map do |calendar_day, supp_days|
      TeamSupportDay.new(day: calendar_day, support_days: supp_days)
    end
  end

  # Groups support days into batches with the same combined team
  # so the start date and end date is a continuous block of time
  # including weekends
  def batched_team_support_days(single_days)
    single_days.chunk_while do |before, after|
      after.developer == before.developer &&
        after.ops_eng == before.ops_eng &&
        after.ooh_person == before.ooh_person &&
        after.day - before.day <= 3
    end
  end

  TeamSupportDay = Struct.new(:day, :support_days, keyword_init: true) {
    def developer
      extract_person_by_discipline(support_days, "dev") ||
        NullPerson.new("Dev TBD")
    end

    def ops_eng
      extract_person_by_discipline(support_days, "ops") ||
        NullPerson.new("Ops TBD")
    end

    def ooh_person
      extract_person_by_discipline(support_days, "ooh") ||
        NullPerson.new("OOH TBD")
    end

    private

    def extract_person_by_discipline(days, discipline)
      days.find { |d| d.support_type == discipline }&.team_member
    end
  }

  NullPerson = Struct.new(:name) {
    def projects
      []
    end
  }
end
