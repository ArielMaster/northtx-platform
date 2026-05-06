class AddFeaturesToPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :plans, :features, :text
  end
end
