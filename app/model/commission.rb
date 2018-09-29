class Commission

  attr_accessor :insurance_fee, :assistance_fee, :drivy_fee

  COMMISSION_PERCENTAGE = 0.3
  INSURANCE_FEE_PERCENTAGE = 0.5

  def initialize(rental)
    global_commission = rental.price * COMMISSION_PERCENTAGE

    @insurance_fee = global_commission * INSURANCE_FEE_PERCENTAGE
    @assistance_fee = rental.days
    @drivy_fee = global_commission - @insurance_fee - @assistance_fee
  end

  def data
    {insurance_fee: @insurance_fee.to_i, assistance_fee: @assistance_fee.to_i, drivy_fee: @drivy_fee.to_i}
  end


end