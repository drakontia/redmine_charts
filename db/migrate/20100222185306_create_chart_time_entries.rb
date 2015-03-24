class CreateChartTimeEntries < ActiveRecord::Migration
  def self.up
    create_table :chart_time_entries do |t|
      t.integer :day, null: false
      t.integer :week, null: false
      t.integer :month, null: false
      t.float :logged_hours, null: false
      t.integer :entries, null: false
      t.integer :user_id, null: false
      t.integer :issue_id, null: true
      t.integer :activity_id, null: true
      t.integer :project_id, null: false
    end
    add_index :chart_time_entries, :day
    add_index :chart_time_entries, :week
    add_index :chart_time_entries, :month
    add_index :chart_time_entries, :user_id
    add_index :chart_time_entries, :issue_id
    add_index :chart_time_entries, :activity_id
    add_index :chart_time_entries, :project_id
  end

  def self.down
    remove_index :chart_time_entries, :day
    remove_index :chart_time_entries, :week
    remove_index :chart_time_entries, :month
    remove_index :chart_time_entries, :user_id
    remove_index :chart_time_entries, :issue_id
    remove_index :chart_time_entries, :activity_id
    remove_index :chart_time_entries, :project_id
    drop_table :chart_time_entries
  end
end
