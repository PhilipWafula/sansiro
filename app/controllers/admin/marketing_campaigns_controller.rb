# frozen_string_literal: true

class Admin::MarketingCampaignsController < ApplicationController
  layout 'admin/application'
  before_action :authenticate_admin!
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
