class CreatePostcodeToWards < ActiveRecord::Migration
  def self.up
    create_table :postcode_to_wards do |t|
      t.string :postcode
      t.integer :ward_id
      t.timestamps
    end
  end

  def self.down
    drop_table :postcode_to_wards
  end
end
