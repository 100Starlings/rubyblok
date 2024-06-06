# frozen_string_literal: true

module DatabaseConfig
  def init_database # rubocop:disable Metrics/MethodLength
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: ':memory:'
    )

    ActiveRecord::Schema.define do
      create_table :page_objects do |t|
        t.string :storyblok_story_id
        t.string :storyblok_story_slug
        t.string :storyblok_story_content

        t.timestamps
      end
    end
  end

  def truncate_database
    ActiveRecord::Base.connection.execute(
      <<-SQL.squish
        DELETE FROM page_objects;
      SQL
    )
  end
end
