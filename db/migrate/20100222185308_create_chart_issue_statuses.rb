class CreateChartIssueStatuses < ActiveRecord::Migration
  def self.up
    create_table :chart_issue_statuses do |t|
      t.integer :day, null: false
      t.integer :week, null: false
      t.integer :month, null: false
      t.integer :project_id, null: false
      t.integer :issue_id, null: false
      t.integer :status_id, null: false
    end
    add_index :chart_issue_statuses, :day
    add_index :chart_issue_statuses, :week
    add_index :chart_issue_statuses, :month
    add_index :chart_issue_statuses, :project_id
    add_index :chart_issue_statuses, :issue_id
  end

  def self.down
    remove_index :chart_issue_statuses, :day
    remove_index :chart_issue_statuses, :week
    remove_index :chart_issue_statuses, :month
    remove_index :chart_issue_statuses, :project_id
    remove_index :chart_issue_statuses, :issue_id
    drop_table :chart_issue_statuses
  end
end
