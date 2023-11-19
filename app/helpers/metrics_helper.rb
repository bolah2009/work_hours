module MetricsHelper
  def start_time_interval(time_string, start_time_string = '09:00')
    time_diff(start_time_string, time_string)
  end

  def end_time_interval(time_string, start_time_string = '17:00')
    time_diff(start_time_string, time_string)
  end

  def time_diff(start_time_string, end_time_string)
    start_time = Time.parse(start_time_string).utc
    end_time = Time.parse(end_time_string).utc
    seconds_diff = (end_time - start_time)
    before_or_after = seconds_diff.negative? ? 'before' : 'after'
    duration = ActiveSupport::Duration.build(seconds_diff.abs)
    "#{duration.inspect} #{before_or_after}"
  end
end
