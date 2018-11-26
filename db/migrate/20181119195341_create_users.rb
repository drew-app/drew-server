class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :email, index: true
      t.string :avatar_url
      t.json :token_details

      t.timestamps
    end
  end
end
