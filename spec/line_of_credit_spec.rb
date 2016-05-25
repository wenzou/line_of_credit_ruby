require 'line_of_credit'

RSpec.describe CreditLine, 'line of credit' do
  let(:line_of_credit) { CreditLine.new(35.0) }

  it 'draw credit' do
    payment_due = line_of_credit.draw_credit(50)
    expect(payment_due).to equal(50)
  end

  it 'draw credit returns false if overdrawn' do
    payment_due = line_of_credit.draw_credit(5000)
    expect(payment_due).to equal(false)
  end

  it 'advance more than 30 days returns remainder_days' do
    days = line_of_credit.advance(61)
    expect(days).to equal(1)
  end

  it 'advance less than 30 days returns remainder_days' do
    days = line_of_credit.advance(29)
    expect(days).to equal(29)
  end

  it 'can calculate interest' do
    allow_any_instance_of(CreditLine).to receive(:payments_due).and_return(100)
    interest = line_of_credit.calculate_interest(30)
    expect(interest).to equal(2.8767123287671232)
  end

  it 'returns a balance' do
    expect(line_of_credit).to_not be_nil
    line_of_credit.draw_credit(500)
    line_of_credit.advance(30)
    return_amount = line_of_credit.balance
    expected_return = 514.38
    expect(return_amount).to equal(expected_return)
  end

  it 'after multiple withdrawn, it returns correct balance' do
    line_of_credit.draw_credit(500)
    line_of_credit.advance(15)
    line_of_credit.make_payment(200)
    line_of_credit.advance(10)
    line_of_credit.draw_credit(100)
    line_of_credit.advance(5)

    return_amount = line_of_credit.balance
    expected_return = 411.99
    expect(return_amount).to equal(expected_return)
  end

  it 'after more than 30 days, the balance and interest are correct' do
    line_of_credit.draw_credit(500)
    line_of_credit.advance(45)
    return_amount = line_of_credit.balance
    expected_return = 514.38
    excepted_current_interest = 7.3986676674798275
    expect(return_amount).to equal(expected_return)
    expect(line_of_credit.interest_charge).to equal(excepted_current_interest)
  end

  it 'after 120 days, the balance is correct' do
    line_of_credit.draw_credit(500)
    line_of_credit.advance(120)
    return_amount = line_of_credit.balance
    expected_return = 560.06
    expect(return_amount).to equal(expected_return)
  end
end
