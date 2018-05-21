require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should belong_to(:credited_account) }
  #TODO check how skip before_validation for RSpec
  #it { should validate_uniqueness_of(:transaction_code) }
end
