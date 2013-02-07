class CreateGardens < ActiveRecord::Migration
  def change
    create_table :gardens do |t|
      t.string :name

      t.timestamps
    end
  end
end
