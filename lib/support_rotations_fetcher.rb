class SupportRotationsFetcher
  OPSGENIE_SCHEDULE_ID = ENV.fetch("OPSGENIE_SCHEDULE_ID", "e71d500f-896a-4b28-8b08-3bfe56e1ed76")

  attr_accessor :historical_interval_in_months, :total_interval_in_months

  def self.detect_stream(timeline_name)
    return "ops" if timeline_name.match?(/ops/i)
    return "dev" if timeline_name.match?(/dev/i)
    return "ooh" if timeline_name.match?(/ooh/i)
    return "phone" if timeline_name.match?(/phone/i)

    timeline_name
  end

  # Discard unassigned periods
  def self.assigned(support_periods)
    support_periods.select { |p| p.user }
  end

  def initialize(historical_interval_in_months: 2, total_interval_in_months: 12)
    @historical_interval_in_months = historical_interval_in_months.to_i
    if @historical_interval_in_months < 1
      @historical_interval_in_months = 1
    end
    if @historical_interval_in_months > 12
      @historical_interval_in_months = 12
    end
    @total_interval_in_months = total_interval_in_months.to_i
    if @total_interval_in_months < @historical_interval_in_months
      @total_interval_in_months = @historical_interval_in_months
    end
  end

  def call
    @timelines ||= schedule.timeline(
      date: Date.today << historical_interval_in_months,
      interval: total_interval_in_months,
      interval_unit: :months
    )
  end

  private

  def schedule
    @schedule ||= Opsgenie::Schedule.find_by_id(OPSGENIE_SCHEDULE_ID)
  end
end

class FirstLineRotationsFetcher < SupportRotationsFetcher
  FIRST_LINE_TIMELINES_REGEX = /(dev)|(ops)|(ooh)/i

  def call
    super.select { |t| t.name.match?(FIRST_LINE_TIMELINES_REGEX) }
  end
end
