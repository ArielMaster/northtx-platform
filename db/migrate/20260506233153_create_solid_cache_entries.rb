class CreateSolidCacheEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :solid_cache_entries do |t|
      t.bigint :key_hash, null: false
      t.binary :value
      t.integer :byte_size
      t.datetime :created_at, null: false
      t.datetime :expires_at
    end

    add_index :solid_cache_entries, :key_hash, unique: true
    add_index :solid_cache_entries, [:key_hash, :byte_size]
  end
end
