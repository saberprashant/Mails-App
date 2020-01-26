class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :userRole
      t.text :mailIds , default: [].to_yaml

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
