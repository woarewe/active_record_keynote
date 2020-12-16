class CreateCommentReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_reactions do |t|
      t.integer :user_id, null: false
      t.integer :comment_id, null: false
      t.integer :type, null: false

      t.timestamps null: false
    end

    add_foreign_key(:comment_reactions, :comments)
    add_foreign_key(:comment_reactions, :users)
    add_index(:comment_reactions, :user_id)
    add_index(:comment_reactions, :comment_id)
  end
end
