class RemoveUserFromRewards < ActiveRecord::Migration[6.0]
  def change
    remove_index :rewards, :user_id
    remove_column :rewards, :user_id, :string
  end
end
