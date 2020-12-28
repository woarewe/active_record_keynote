class ChangeForeignKeyToCascade < ActiveRecord::Migration[6.1]
  def up
    remove_foreign_key(:posts, :users)
    remove_foreign_key(:comments, :posts)
    remove_foreign_key(:comments, :users)
    remove_foreign_key(:comment_reactions, :comments)
    remove_foreign_key(:comment_reactions, :users)

    add_foreign_key(:posts, :users, on_delete: :cascade)
    add_foreign_key(:comments, :posts, on_delete: :cascade)
    add_foreign_key(:comments, :users, on_delete: :cascade)
    add_foreign_key(:comment_reactions, :comments, on_delete: :cascade)
    add_foreign_key(:comment_reactions, :users, on_delete: :cascade)
  end

  def down
    remove_foreign_key(:posts, :users)
    remove_foreign_key(:comments, :posts)
    remove_foreign_key(:comments, :users)
    remove_foreign_key(:comment_reactions, :comments)
    remove_foreign_key(:comment_reactions, :users)

    add_foreign_key(:posts, :users)
    add_foreign_key(:comments, :posts)
    add_foreign_key(:comments, :users)
    add_foreign_key(:comment_reactions, :comments)
    add_foreign_key(:comment_reactions, :users)
  end
end
