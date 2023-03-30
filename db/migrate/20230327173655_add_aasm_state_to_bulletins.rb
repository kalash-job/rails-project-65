class AddAasmStateToBulletins < ActiveRecord::Migration[7.0]
  def change
    add_column :bulletins, :state, :string, default: 'draft'
  end
end
