class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.string :name
      t.string :url
      t.boolean :video
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
