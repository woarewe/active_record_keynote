class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps null: false
    end

    add_foreign_key(:posts, :users)
    add_index(:posts, :user_id)
  end
end
