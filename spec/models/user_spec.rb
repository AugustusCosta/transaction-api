require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:accounts) }
  it { should have_one(:physical_person) }
  it { should have_one(:legal_person) }
end
