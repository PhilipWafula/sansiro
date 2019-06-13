# frozen_string_literal: true

require 'smarter_csv'
class Admin::MarketingCampaignsController < ApplicationController
  protect_from_forgery with: :null_session
  layout 'admin/application'
  before_action :authenticate_admin!
  # before_action :authenticate_admin!
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: MarketingCampaignsDatatable.new(params)
      end
    end
    @marketing_campaigns = MarketingCampaign.all
    @campaigns_sent = @marketing_campaigns.count
  end

  def show
    @marketing_campaign = MarketingCampaign.find(params[:id])
  end

  def new
    @marketing_campaign = MarketingCampaign.new
  end

  def create
    puts process_bulk_recipients(params)
  end

  private

  def marketing_campaign_params
    params.require(:marketing_campaign).permit(:message_body, :recipients_file)
  end

  # calculated percentages for dashboard
  def percentage_changes(value)
    to_f / value.to_f * 100.0
  end

  def process_bulk_recipients(params)
    if params.try(:[], :marketing_campaign).try(:[], :recipients_file).blank? || params.try(:[], :marketing_campaign).try(:[], :message_body).blank?
      puts 'NO FILE SELECTED'
      redirect_to new_admin_marketing_campaign_path, flash: { error: 'No file was selected or message was added' }
    else
      # get file path
      input_path = params[:marketing_campaign][:recipients_file].path

      # get message body
      message_body = params[:marketing_campaign][:message_body]

      # parse into an array with hashes
      recipients = SmarterCSV.process(input_path)

      # Offset to worker
      ProcessCsvWorker.perform_async(recipients, message_body)

      # redirect to marketing campaigns
      redirect_to admin_marketing_campaigns_path
    end
  end
end
