class User < ApplicationRecord
	has_one :legal_person
	has_one :physical_person
	has_many :accounts
end
