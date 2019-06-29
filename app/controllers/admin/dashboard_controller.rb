class Admin::DashboardController < AdminController
  before_action :authenticate_admin!
  def index
    # pending transactions
    set_pending_transactions

    # scheduled transactions
    set_scheduled_transactions

    # daily earnings
    compute_daily_earnings

    # monthly earnings
    compute_monthly_earnings
  end

  private

  def set_pending_transactions
    @pending_transactions = PendingTransaction.all.count
  end

  def set_scheduled_transactions
    @scheduled_transactions = MpesaTransaction.all.count
  end

  def compute_daily_earnings
    # get current date
    current_date = Date.today

    # define packages
    @regular_count = message_per_package_count('Regular', current_date)
    @premium_count = message_per_package_count('Premium', current_date)
    @jackpot_count = message_per_package_count('Jackpot', current_date)

    # compute total earnings for the day
    @daily_earnings = total_revenue(@regular_count, @premium_count, @jackpot_count)
  end

  def compute_monthly_earnings
    # get monthly time frame
    monthly_time_frame = Time.zone.now.beginning_of_month..Time.zone.now.end_of_month

    # define packages
    @regular_count = message_per_package_count('Regular', monthly_time_frame)
    @premium_count = message_per_package_count('Premium', monthly_time_frame)
    @jackpot_count = message_per_package_count('Jackpot', monthly_time_frame)

    # compute total earnings for the month
    @monthly_earnings = total_revenue(@regular_count, @premium_count, @jackpot_count)
  end

  def message_per_package_count(package, date)
    @package = Tip.where(tip_package: package, tip_date: date).count
  end

  def total_revenue(regular, premium, jackpot)
    ((50 * regular) + (100 * premium) + (80 * jackpot))
  end
end
