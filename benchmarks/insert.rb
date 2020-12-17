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
  def self.using_create
    ActiveRecord::Base.transaction do
      DATA.each { |params| Contact.create!(params) }

      raise ActiveRecord::Rollback
    end
  end

  def self.raw_sql
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
    SQL
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute(sql)

      raise ActiveRecord::Rollback
    end
  end

  def self.rails_6_insert_all
    ActiveRecord::Base.transaction do
      Contact.insert_all!(DATA)

      raise ActiveRecord::Rollback
    end
  end

  def self.gem_active_record_import
    ActiveRecord::Base.transaction do
      Contact.import!(DATA)

      raise ActiveRecord::Rollback
    end
  end
end

Benchmark.ips do |x|
  x.report('each and create') { Service.using_create }
  x.report('raw sql') { Service.raw_sql }
  x.report('Rails 6 insert_all') { Service.rails_6_insert_all }
  x.report('gem import') { Service.gem_active_record_import }

  x.compare!
end
