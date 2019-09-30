class CreateClocks < ActiveRecord::Migration[5.2]
  def change
    create_table :clocks do |t|
      t.datetime :clock_in_time, null: false
      t.datetime :clock_out_time
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
