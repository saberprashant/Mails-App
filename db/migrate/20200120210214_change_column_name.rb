class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :role, :userRole
  end
end
