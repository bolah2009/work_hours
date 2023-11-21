class MetricsController < ApplicationController
  before_action :set_organization_id

  def new; end

  def create
    @metric = Metric.new(metric_params)

    if @metric.save
      redirect_back fallback_location: root_path, notice: 'Metric was successfully created.'
    else
      set_flash(notice: @metric.errors.first.full_message, notice_type: :error)
      redirect_to organization_path(@organization_id)
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def metric_params
    current_params = params.require(:metric).permit(:start_time, :end_time)
    organization_id = @organization_id
    user_id = current_user_id
    date = Time.zone.today
    current_params.merge({ organization_id:, user_id:, date: })
  end

  def set_organization_id
    @organization_id = params[:organization_id]
  end
end
