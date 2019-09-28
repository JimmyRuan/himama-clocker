class CreateClocks < ActiveRecord::Migration[5.2]
  def change
    create_table :clocks do |t|
      t.boolean :clocked_in
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
