class AddUniqueIndexForSlug < ActiveRecord::Migration[8.0]
  def change
    # Prevents or handles race conditions
    add_index :tasks, :slug, unique: true
  end
end
