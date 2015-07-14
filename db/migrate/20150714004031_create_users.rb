class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid, index: true
      t.string :name
      t.string :token, index: true
      t.string :secret
      t.string :profile_image

      t.timestamps null: false
    end
  end
end
