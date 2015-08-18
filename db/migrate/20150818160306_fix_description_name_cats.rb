class FixDescriptionNameCats < ActiveRecord::Migration
  def change
    rename_column :cats, :desription, :description
  end
end
