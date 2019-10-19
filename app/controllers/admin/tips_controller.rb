# frozen_string_literal: true

class Admin::TipsController < ApplicationController
  before_action :set_tip, only: %i[show edit update destroy]
  before_action :authenticate_admin!
  layout 'admin/application'
  include_all_helpers
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: TipsDatatable.new(params)
      end
    end
    @regular_count = message_per_package_count('Regular')
    @premium_count = message_per_package_count('Premium')
    @jackpot_count = message_per_package_count('Jackpot')
    @tip_count_by_month = Tip.tip_count_by_month
    @total_tip_count = Tip.total_tips_generated
  end

  # GET /admin/tips/1
  # GET /admin/tips/1.json
  def show
    set_tip
  end

  # GET /admin/tips/new
  def new
    @tip = Tip.new
  end

  # GET /admin/tips/1/edit
  def edit
    set_tip
  end

  # POST /admin/tips
  # POST /admin/tips.json
  def create
    @current_admin = Admin.find(current_admin.id)
    @tip = @current_admin.tips.new(process_tip_params(tip_params))
    respond_to do |format|
      if @tip.save
        format.html { redirect_to [:admin, @tip], notice: 'Tip was successfully created.' }
        format.json { render :show, status: :created, location: @tip }
      else
        format.html { render :new }
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tips/1
  # PATCH/PUT /admin/tips/1.json
  def update
    respond_to do |format|
      if @tip.update(tip_params)
        format.html { redirect_to [:admin, @tip], notice: 'Tip was successfully updated.' }
        format.json { render :show, status: :ok, location: @tip }
      else
        format.html { render :edit }
        format.json { render json: @tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tips/1
  # DELETE /admin/tips/1.json
  def destroy
    @tip.destroy
    respond_to do |format|
      format.html { redirect_to admin_tips_url, notice: 'Tip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tip
    @tip = Tip.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tip_params
    params.require(:tip).permit(:tip_package,
                                :tip_sender,
                                :tip_expiry,
                                :tip_date,
                                :tip_content)
  end

  def process_tip_params(params)
    params[:tip_date] = params[:tip_date].to_date
    params[:tip_expiry] = Time.parse(params[:tip_expiry])
    params
  end

  def message_per_package_count(package)
    @package = Tip.where(tip_package: package).count
  end

end
