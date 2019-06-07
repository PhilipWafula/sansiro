# frozen_string_literal: true

require 'csv'

class Admin::MarketingCampaignsController < ApplicationController
  protect_from_forgery with: :null_session
  layout 'admin/application'
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

  def multiple_recipients_campaign
    if params.try(:[], :marketing_campaigns).try(:[], :recipients_file).blank?
      flash[:error] = 'No file was selected'
      redirect_to admin_marketing_campaigns_multiple_recipients_campaign_path
    elsif params.try(:[], :marketing_campaigns).try(:[], :message_body).blank?
      flash[:error] = 'No message received'
    else
      recipients_file = params[:marketing_campaigns][:recipients_file].read
      recipients = []
      message = params[:marketing_campaigns][:message_body]
      begin
        CSV.new(recipients_file, headers: true, skip_blanks: true).each do |row|
          recipients << PhoneService.internationalize_phone(row[0].to_s.strip, 'KE')
        end
      rescue CSV::MalformedCSVError
        flash.now[:error] = 'The file imported has an invalid format'
      rescue StandardError
        flash.now[:error] = 'Import failed - Internal application error'
      end

      unless recipients.blank?
        recipients.each do |recipient|
          BulkSms::AfricasTalkingSms.new.relay_message(recipient, message)
          campaigns = MarketingCampaign.new do |campaign|
            campaign.message_recipient = recipient
            campaign.message_body = message
          end
          campaigns.save!
        end
        redirect_to admin_marketing_campaigns_path
      end
    end
  end

  def create
    @marketing_campaign = MarketingCampaign.new(marketing_campaign_params)

    # BulkSmsWorker.perform_async(@marketing_campaign.message_recipient, @marketing_campaign.message_body)
    BulkSms::AfricasTalkingSms.new.relay_message(@marketing_campaign.message_recipient, @marketing_campaign.message_body)

    if @marketing_campaign.save
      respond_to do |format|
        format.html { redirect_to [:admin, @marketing_campaign], notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @marketing_campaign] }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: [:admin, @marketing_campaign].errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def marketing_campaign_params
    params.require(:marketing_campaign).permit(:message_body, :message_recipient)
  end

  def percentage_changes(value)
    to_f / value.to_f * 100.0
  end
end
