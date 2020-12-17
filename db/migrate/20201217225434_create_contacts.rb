class CreateContacts < ActiveRecord::Migration[6.1]
  TABLE = :contacts

  def up
    create_table(TABLE)  do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false

      t.timestamps null: false
    end

    execute(
      <<~SQL
        ALTER TABLE #{TABLE}
        ADD CONSTRAINT #{TABLE}_email_uniq UNIQUE (email)
      SQL
    )
  end

  def down
    drop_table(TABLE)
  end
end
