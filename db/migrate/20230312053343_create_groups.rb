class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :organization_id
      t.string :uuid

      t.timestamps
    end
  end
end
