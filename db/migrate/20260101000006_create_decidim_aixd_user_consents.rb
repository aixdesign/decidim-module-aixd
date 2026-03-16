# frozen_string_literal: true

class CreateDecidimAixdUserConsents < ActiveRecord::Migration[7.0]
  def change
    create_table :decidim_aixd_user_consents do |t|
      t.references :user, null: false, foreign_key: { to_table: :decidim_users }, index: true
      t.string  :feature,   null: false
      t.boolean :opted_out, null: false, default: false

      t.timestamps
    end

    add_index :decidim_aixd_user_consents, %i[user_id feature],
              unique: true,
              name: "idx_decidim_aixd_user_consents_unique"
  end
end
