class CreateAvitos < ActiveRecord::Migration
  def change
    create_table :avitos do |t|
      t.timestamps null: false
    end
  end
end
