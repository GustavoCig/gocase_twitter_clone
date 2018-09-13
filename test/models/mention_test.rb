require 'test_helper'

class MentionTest < ActiveSupport::TestCase
  test "correct use of mention regex should generate a mention in the database" do
    
  end

  test "incorrect use of the regular expression shouldn't generate a mention in the database" do
    
  end

  test "user self mentioning shouldn't generate a mention" do

  end

  test "many equal mentions in a single tweet shouldn't generate more than one mention in the database" do

  end
end
