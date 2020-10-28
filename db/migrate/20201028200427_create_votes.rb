class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.belongs_to :voteable, polymorphic: true

      t.timestamps
    end
  end
end
