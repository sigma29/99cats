class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.date   :birthdate, null: false
      t.string :color, null: false
      t.string :name, null: false
      t.string :sex, null: false
      t.text   :desription

      t.timestamps
    end
  end
end
