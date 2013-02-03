class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :name
      t.string :owner
      t.string :mac

      t.timestamps
    end
  end
end
