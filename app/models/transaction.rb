require 'securerandom'
class Transaction < ApplicationRecord
  after_create :change_values
  after_update :change_values_reversed
	before_validation :generate_transaction_code
	validates :transaction_code, uniqueness: true
	validate :credited_account_status, :debited_account_status, :debited_account_amount, :main_account_transaction, :same_tree_accounts
	validate :reversed_transaction, on: :update
  has_one :debited_account, :class_name => 'Account', :foreign_key => 'debited_account_id'
	belongs_to :credited_account, :class_name => 'Account', :foreign_key => 'credited_account_id'

  def self.search_transaciont(startDate, endDate)
    if startDate == nil
      startDate = Time.now - 30.years
    end
    if endDate == nil
      endDate = Time.now
    end
    Transaction.where(created_at: startDate..endDate)
  end

  private

    def change_values
      credited_account.amount = credited_account.amount + amount
      credited_account.save
      if debited_account_id != nil
        account = Account.find_by_id(debited_account_id)
        account.amount = credited_account.amount - amount
        account.save
      end
    end

    def change_values_reversed
      credited_account.amount = credited_account.amount - amount
      credited_account.save
      if debited_account_id != nil
        account = Account.find_by_id(debited_account_id)
        account.amount = credited_account.amount + amount
        account.save
      end
    end

	  def generate_transaction_code
    	self.transaction_code = SecureRandom.base64
  	end

  	def credited_account_status
  		account = Account.find_by_id(credited_account_id)
  		if account != nil && account.status != 0
      		errors.add(:credited_account, "is not active")
      	end
  	end

  	def debited_account_status
  		account = Account.find_by_id(debited_account_id)
  		if account != nil && account.status != 0
      		errors.add(:debited_account, "is not active")
      	end
  	end

  	def debited_account_amount
  		account = Account.find_by_id(debited_account_id)
  		if account != nil
  			if amount > account.amount
  				errors.add(:debited_account, "not have the amount to transfer")
  			end
      	end
  	end

  	def main_account_transaction
  		account = Account.find_by_id(credited_account_id)
  		if account != nil && account.root?
      		if debited_account_id != nil && debited_account_id != 0
      			errors.add(:credited_account, "not accepts transaction, only deposit")
      		end
      	end
  	end

  	def same_tree_accounts
  		if debited_account_id != nil && debited_account_id != 0
  			debited_account_validation = Account.find_by_id(debited_account_id)
  			credited_account_validation = Account.find_by_id(credited_account_id)
  			unless credited_account_validation.root?
  				debited_account_root_id = nil
  				if debited_account_validation.root?
  					debited_account_root_id = debited_account_validation.id
  				else
  					debited_account_root_id = debited_account_validation.root.id
  				end
  				if debited_account_root_id != credited_account_validation.root.id
  					errors.add(:credited_account, "accounts shold have the same root")
  				end
  			end
  		end
  	end

    def reversed_transaction
      if reversed
        account = Account.find_by_id(credited_account_id)
        if amount > account.amount
          errors.add(:reversed, "debited account not have the amount")
        end
      end
    end

end
