class CreateChartSavedConditions < ActiveRecord::Migration
  def self.up
    create_table :chart_saved_conditions do |t|
      t.string :name, null: false
      t.integer :project_id, null: true
      t.string :conditions, null: false
      t.string :chart, null: false
    end
    add_index :chart_saved_conditions, :project_id
  end

  def self.down
    remove_index :chart_saved_conditions, :project_id
    drop_table :chart_saved_conditions
  end
end
