# A line of credit product.  This is like a credit card except theres no card
class CreditLine
  attr_reader :interest_charge

  def initialize(apr = 5.0, credit_limit = 1000)
    @apr = apr
    @credit_limit = credit_limit
    @payments_due = 0
    @interest_charge = 0
    @days = 0
  end

  def balance
    # this get the principle balance rounded to the nearest 2 decimal places
    payments_due.round(2)
  end

  def draw_credit(draw_amount)
    total = payments_due + draw_amount
    return false if credit_limit < total
    @payments_due = total
  end

  def advance(days)
    return false if days < 0
    total_days = @days + days
    days_over_30_days = total_days - 30
    charge(days_over_30_days, days)
    @days
  end

  def charge(days_over_30_days, days)
    if days_over_30_days >= 0
      times_of_30, remainder_days = days_over_30_days.divmod(30)
      calculate_payment(times_of_30)
      @interest_charge += calculate_interest(remainder_days)
      @days = remainder_days
    else
      @interest_charge += calculate_interest(days)
      @days += days
    end
  end

  def calculate_payment(times_of_30)
    @payments_due += calculate_interest((30 - @days))
    (0...times_of_30).each do
      @payments_due += calculate_interest(30)
    end
    @payments_due += interest_charge
  end

  def calculate_interest(days_of_interest)
    payments_due * apr / 100 / 365 * days_of_interest
  end

  def make_payment(amount)
    # paydown your balance
    @payments_due -= amount
  end

  private

  attr_reader :payments_due, :credit_limit, :apr
end
