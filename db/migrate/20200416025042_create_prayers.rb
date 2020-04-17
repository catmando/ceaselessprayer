class CreatePrayers < ActiveRecord::Migration[5.2]
  def change
    create_table :prayers do |t|
      t.string  :ip
      t.decimal :lat
      t.decimal :long

      t.timestamps
    end
  end
end
