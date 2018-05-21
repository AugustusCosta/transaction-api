# spec/requests/transactions_spec.rb
require 'rails_helper'

RSpec.describe 'Transactions API', type: :request do
  # initialize test data 

  let!(:user)                 { create(:user)}
  let!(:main_account_1)       { create(:account, user_id: user.id)}
  let!(:account_1_1)          { create(:account, user_id: user.id, parent: main_account_1)}
  let!(:account_1_2)          { create(:account, user_id: user.id, parent: main_account_1)}
  let!(:account_1_blocked)    { create(:account, user_id: user.id, parent: main_account_1, status: 1)}
  let!(:main_account_2)       { create(:account, user_id: user.id)}
  let!(:account_2_1)          { create(:account, user_id: user.id, parent: main_account_2)}
  let!(:account_2_2)          { create(:account, user_id: user.id, parent: main_account_2)}

  let!(:transactions)   { create_list(:transaction, 10, credited_account_id: main_account_1.id) }
  


   # Test suite for SEARCH /transactions
  describe 'SEARCH /transactions' do
    
    context 'when the request is valid with no date search' do
      before { get '/transactions' }
        it 'returns transactions' do
          expect(JSON.parse(response.body)).not_to be_empty
          expect(JSON.parse(response.body).size).to eq(10)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the request is valid with end date search' do
        before { get '/transactions', params: {end_date: Time.now + 1.years} }
        it 'returns transactions' do
          expect(JSON.parse(response.body)).not_to be_empty
          expect(JSON.parse(response.body).size).to eq(10)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the request is valid with start date search' do
        before { get '/transactions', params: {start_date: Time.now - 5.years } }
        it 'returns transactions' do
          expect(JSON.parse(response.body)).not_to be_empty
          expect(JSON.parse(response.body).size).to eq(10)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the request is valid with start and end date search' do
        before { get '/transactions', params: {start_date: Time.now - 5.years,  end_date: Time.now + 6.years} }
        it 'returns transactions' do
          expect(JSON.parse(response.body)).not_to be_empty
          expect(JSON.parse(response.body).size).to eq(10)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the request is valid with start and end date search but return nothing' do
        before { get '/transactions', params: {start_date: Time.now - 5.years,  end_date: Time.now - 3.years} }
        it 'returns transactions' do
          expect(JSON.parse(response.body)).to be_empty
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

  end
  
  
  # Test suite for CREATE /transactions
  describe 'CREATE /transactions' do
    context 'when debited account not have the amount to transfer' do
      let(:transaction) { { amount: 1000, credited_account_id: account_1_1.id, debited_account_id: account_1_2.id} }
      before { post '/transactions', params: transaction }

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("Validation failed: Debited account not have the amount to transfer")
      end
    end

    context 'when main accounts not accepts transaction, only deposit' do
      let(:transaction) { { amount: 10, credited_account_id: main_account_1.id, debited_account_id: account_1_2.id} }
      before { post '/transactions', params: transaction }

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("Validation failed: Credited account not accepts transaction, only deposit")
      end
    end

    context 'when accounts shold have the same root' do
      let(:transaction) { { amount: 10, credited_account_id: account_2_1.id, debited_account_id: account_1_2.id} }
      before { post '/transactions', params: transaction }

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("Validation failed: Credited account accounts shold have the same root")
      end
    end

    context 'when credited account is not active' do
      let(:transaction) { { amount: 10, credited_account_id: account_1_blocked.id, debited_account_id: account_1_2.id} }
      before { post '/transactions', params: transaction }

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("Validation failed: Credited account is not active")
      end
    end

    context 'when debited account is not active' do
      let(:transaction) { { amount: 10, credited_account_id: account_1_2.id, debited_account_id: account_1_blocked.id} }
      before { post '/transactions', params: transaction }

      it 'returns a validation failure message' do
        expect(response.body)
          .to match("Validation failed: Debited account is not active")
      end
    end

    context 'when the request is valid' do
      let(:transaction) { { amount: 10, credited_account_id: account_1_2.id, debited_account_id: account_1_1.id} }
      before { post '/transactions', params: transaction }

      it 'creates a transaction' do
        expect(JSON.parse(response.body)['credited_account_id']).to eq(account_1_2.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

  end

  # Test suite for GET /transactions/:id
  describe 'GET /transactions/:id' do
    context 'when the record exists' do
      let(:transaction) { create(:transaction, amount: 10, credited_account_id: account_1_2.id, debited_account_id: account_1_1.id)}
      let(:transaction_id) { transaction.id }
      before { get "/transactions/#{transaction.id}" }
      it 'returns the transaction' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(transaction.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:transaction_id) { 100 }
      before { get "/transactions/#{transaction_id}" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match("Couldn't find Transaction with 'id'=100")
      end
    end
  end


  # Test suite for REVERSED /transactions/:id
  describe 'REVERSED /transactions/:id' do
    let(:transaction) { create(:transaction, amount: 10, credited_account_id: account_1_2.id, debited_account_id: account_1_1.id)}
    let(:transaction_id)  { transaction.id }
    let(:valid_attributes) { { reversed: true } }

    context 'when the record exists' do
      before { put "/transactions/#{transaction_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end