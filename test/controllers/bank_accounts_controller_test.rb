require 'test_helper'

class BankAccountsControllerTest < ActionDispatch::IntegrationTest
  
  test "should redirect if not logged in" do
    get '/bank_accounts/new'
    assert_redirected_to user_session_path
  end

end
