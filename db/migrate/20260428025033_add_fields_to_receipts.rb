class AddFieldsToReceipts < ActiveRecord::Migration[8.1]
  def change
    add_column :receipts, :plan_name, :string
    add_column :receipts, :name, :string
    add_column :receipts, :email, :string
    add_column :receipts, :amount, :integer
  end
end
