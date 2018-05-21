class Account < ApplicationRecord
	belongs_to :user
	has_many :debits, :class_name => 'Transaction', :foreign_key => 'debited_account_id'
	has_many :credits, :class_name => 'Transaction', :foreign_key => 'credited_account_id'
	acts_as_tree
end
