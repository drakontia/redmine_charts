class CreateChartDoneRatios < ActiveRecord::Migration
  def self.up
    create_table :chart_done_ratios do |t|
      t.integer :day, null: false
      t.integer :week, null: false
      t.integer :month, null: false
      t.integer :project_id, null: false
      t.integer :issue_id, null: false
      t.integer :done_ratio, null: false
    end
    add_index :chart_done_ratios, :day
    add_index :chart_done_ratios, :week
    add_index :chart_done_ratios, :month
    add_index :chart_done_ratios, :project_id
    add_index :chart_done_ratios, :issue_id
  end

  def self.down
    remove_index :chart_done_ratios, :day
    remove_index :chart_done_ratios, :week
    remove_index :chart_done_ratios, :month
    remove_index :chart_done_ratios, :project_id
    remove_index :chart_done_ratios, :issue_id
    drop_table :chart_done_ratios
  end
end
