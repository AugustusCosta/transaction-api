require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should have_many(:debits) }
  it { should have_many(:credits) }
end
