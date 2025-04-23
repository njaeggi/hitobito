class AddHitobitoThemeTable < ActiveRecord::Migration[7.0]
  def change
    create_table :hitobito_themes do |t|
      t.string :name
      t.string :link_color
      t.string :link_hover_color
      t.string :primary_color
      t.string :secondary_color
      t.string :page_background_color
      t.string :content_background_color
      t.string :footer_background_color
    end
  end
end
