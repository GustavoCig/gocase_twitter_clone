class ChangeDefaultValueOfNumberOfLikesInTweets < ActiveRecord::Migration[5.2]
  def change
    change_column :tweets, :number_of_likes, :integer, :default => 0
  end
end
