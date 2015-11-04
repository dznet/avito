class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :secondname
      t.string :email
      t.string :password
      t.enum :role

      t.timestamps null: false
    end
  end
end
