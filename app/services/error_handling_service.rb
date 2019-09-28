class ErrorHandlingService
  def initialize(tip)
    @tip = tip
  end

  def perform
    test_tip_creation
  end

  private

  def test_tip_creation
    @tip.tip_content = 'SAMPLE TIP'
    @tip.tip_date = Date.today
    @tip.tip_expiry = Time.now
    @tip.tip_package = 'Regular'
    @tip.save!
  end
end