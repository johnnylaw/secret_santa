class AddPreferencesToSantas < ActiveRecord::Migration[7.1]
  def change
    add_column :santas, :preferences, :text, default: "", null: false
    add_column :santas, :pronoun, :string, default: "", null: false
  end
end
