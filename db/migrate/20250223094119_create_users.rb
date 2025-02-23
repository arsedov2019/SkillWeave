class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :email
      t.integer :age
      t.string :nationality
      t.string :country
      t.string :gender

      t.timestamps
    end
  end
end
