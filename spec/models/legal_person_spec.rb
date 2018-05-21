require 'rails_helper'

RSpec.describe LegalPerson, type: :model do
  it { should belong_to(:user) }
end
