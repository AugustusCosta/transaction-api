class TransactionsController < ApplicationController
	before_action :set_transaction, only: [:update, :show]

  # GET /transactions
  def index
    if params['start_date'] || params['end_date']
      @transactions = Transaction.search_transaciont(params['start_date'], params['end_date'])
    else
      @transactions = Transaction.all
    end
    json_response(@transactions)
  end

  # GET /transactions/:id
  def show
    json_response(@transaction)
  end


  # POST /transactions
  def create
    @transaction = Transaction.create!(transaction_params)
    json_response(@transaction, :created)
  end

  # PUT /transactions/:id
  def update
    @transaction.update(transaction_params)
    head :no_content
  end

  private

  def transaction_params
    # whitelist params
    params.permit(:amount, :credited_account_id, :debited_account_id, :reversed, :start_date)
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
