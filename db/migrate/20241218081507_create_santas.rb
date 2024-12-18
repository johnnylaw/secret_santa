class CreateSantas < ActiveRecord::Migration[7.1]
  def change
    create_table :santas do |t|
      t.uuid :permalink, null: false
      t.string :name, null: false
      t.references :recipient, foreign_key: { to_table: :santas }
      t.references :banned_recipient, foreign_key: { to_table: :santas }
    end
  end
end
