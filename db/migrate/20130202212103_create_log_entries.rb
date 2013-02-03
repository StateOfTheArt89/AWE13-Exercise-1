class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.string :mac
      t.string :ip
      t.datetime :went_on
      t.datetime :went_off

      t.timestamps
    end
  end
end
