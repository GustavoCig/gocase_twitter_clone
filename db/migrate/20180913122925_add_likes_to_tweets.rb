class AddLikesToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :likes, :integer, :after => :message
  end
end
