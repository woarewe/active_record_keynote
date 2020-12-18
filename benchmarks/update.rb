require_relative '../config/environment'

DATA = Array.new(1000) do |i|
  {
    email: "contact#{i}@mail.com",
    first_name: "first_name#{i}",
    last_name: "last_name#{i}",
    created_at: Time.now,
    updated_at: Time.now
  }
end

class Service
  def self.find_and_update
    ActiveRecord::Base.transaction do
      DATA.each do |params|
        contact = Contact.find_by(email: params.fetch(:email))
        if contact
          contact.update!(params)
        else
          Contact.create!(params)
        end
      end
      raise ActiveRecord::Rollback
    end
  end

  def self.manual_upsert
     rows = DATA.map do |params|
      [
        "'#{params.fetch(:email)}'",
        "'#{params.fetch(:first_name)}'",
        "'#{params.fetch(:last_name)}'",
        "'#{params.fetch(:created_at).to_s(:db)}'",
        "'#{params.fetch(:updated_at).to_s(:db)}'",
      ]
    end
    sql = <<~SQL
      INSERT INTO contacts
      (email, first_name, last_name, created_at, updated_at)
      VALUES
      #{rows.map { |row| "(#{row.join(',') })" }.join(',')}
      ON CONFLICT (email)
      DO UPDATE
      SET first_name = EXCLUDED.first_name,
      last_name = EXCLUDED.last_name,
      created_at = EXCLUDED.created_at,
      updated_at = EXCLUDED.updated_at
    SQL

    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute(sql)
      raise ActiveRecord::Rollback
    end
  end

  def self.rails_6_upsert_all
    ActiveRecord::Base.transaction do
      Contact.upsert_all(DATA, unique_by: :email)

      raise ActiveRecord::Rollback
    end
  end

  def self.gem_import_with_options
    ActiveRecord::Base.transaction do
      Contact.import!(
        DATA,
        on_duplicate_key_update: {
          conflict_target: :email,
          columns: [:first_name, :last_name, :created_at, :updated_at]
        }
      )

      raise ActiveRecord::Rollback
    end
  end
end



Benchmark.ips(30) do |x|
  x.report('create or update') { Service.find_and_update }
  x.report('manual upsert') { Service.manual_upsert }
  x.report('rails 6 upsert_all') { Service.rails_6_upsert_all }
  x.report('gem import') { Service.gem_import_with_options }

  x.compare!
end
