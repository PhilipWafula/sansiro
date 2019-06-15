# frozen_string_literal: true

class Admin::TipsController < ApplicationController
  before_action :set_admin_tip, only: %i[show edit update destroy]
  before_action :authenticate_admin!
  layout 'admin/application'
  def index
    respond_to do |format|
      format.html
      format.json do
        render json: AdminTipDatatable.new(params)
      end
    end
    @regular_count = message_per_package_count('Regular')
    @premium_count = message_per_package_count('Premium')
    @jackpot_count = message_per_package_count('Jackpot')
    @total_revenue = total_revenue @regular_count, @premium_count, @jackpot_count
  end

  # GET /admin/tips/1
  # GET /admin/tips/1.json
  def show
    set_admin_tip
  end

  # GET /admin/tips/new
  def new
    @admin_tip = Admin::Tip.new
  end

  # GET /admin/tips/1/edit
  def edit
    set_admin_tip
  end

  # POST /admin/tips
  # POST /admin/tips.json
  def create
    @admin = Admin.find(current_admin.id)
    @admin_tip = @admin.admin_tips.create(admin_tip_params)
    respond_to do |format|
      if @admin_tip.save
        format.html { redirect_to @admin_tip, notice: 'Tip was successfully created.' }
        format.json { render :show, status: :created, location: @admin_tip }
      else
        format.html { render :new }
        format.json { render json: @admin_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tips/1
  # PATCH/PUT /admin/tips/1.json
  def update
    respond_to do |format|
      if @admin_tip.update(admin_tip_params)
        format.html { redirect_to @admin_tip, notice: 'Tip was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_tip }
      else
        format.html { render :edit }
        format.json { render json: @admin_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tips/1
  # DELETE /admin/tips/1.json
  def destroy
    @admin_tip.destroy
    respond_to do |format|
      format.html { redirect_to admin_tips_url, notice: 'Admin::Tip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_tip
    @admin_tip = Admin::Tip.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_tip_params
    params.require(:admin_tip).permit(:tip_package, :tip_date, :tip_content)
  end

  def message_per_package_count(package)
    @package = Admin::Tip.where(tip_package: package).count
  end

  def total_revenue(regular, premium, jackpot)
    ((50 * regular) + (100 * premium) + (80 * jackpot))
  end
end
