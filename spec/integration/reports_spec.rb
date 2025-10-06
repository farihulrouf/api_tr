require 'swagger_helper'

RSpec.describe 'Reports API', type: :request do
  path '/reports/top_crypto_users' do
    get('top crypto users report') do
      tags 'Reports'
      produces 'application/json'

      response(200, 'successful') do
        description 'Return list of top users based on crypto holdings'
        schema type: :object,
               properties: {
                 users: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       user_id: { type: :integer },
                       username: { type: :string },
                       total_crypto_value: { type: :number }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/reports/balance_comparison' do
    get('balance comparison report') do
      tags 'Reports'
      produces 'application/json'

      response(200, 'successful') do
        description 'Compare balances between users or time periods'
        schema type: :object,
               properties: {
                 average_balance: { type: :number },
                 median_balance: { type: :number },
                 comparison_result: { type: :string }
               }

        run_test!
      end
    end
  end

  path '/reports/top_balance_change_day' do
    get('top balance change day report') do
      tags 'Reports'
      produces 'application/json'

      response(200, 'successful') do
        description 'Show the day with the largest balance change'
        schema type: :object,
               properties: {
                 date: { type: :string, format: :date },
                 total_change: { type: :number },
                 top_user: {
                   type: :object,
                   properties: {
                     user_id: { type: :integer },
                     username: { type: :string },
                     change: { type: :number }
                   }
                 }
               }

        run_test!
      end
    end
  end
end
