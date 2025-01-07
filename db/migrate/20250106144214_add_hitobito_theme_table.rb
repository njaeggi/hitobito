class AddHitobitoThemeTable < ActiveRecord::Migration[7.0]
  def change
    create_table :hitobito_themes do |t|
      t.string :name
      t.string :color
    end
  end
end
