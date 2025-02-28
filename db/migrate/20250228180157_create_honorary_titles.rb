class CreateHonoraryTitles < ActiveRecord::Migration[8.0]
  def change
    create_table :honorary_titles do |t|
      t.string :title
      t.string :slogan

      t.timestamps
    end
  end
end
