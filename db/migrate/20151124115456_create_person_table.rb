class CreatePersonTable < ActiveRecord::Migration
  def self.up
    create_table :persons, id: false do |t|
      t.timestamps
      t.jsonb :extras
      t.text :locked_fields, array: true
      t.string :id, limit: 47
      t.string :name, limit: 300
      t.string :sort_name, limit: 100
      t.string :family_name, limit: 100
      t.string :given_name, limit: 100
      t.string :image, limit: 2000
      t.string :gender, limit: 100
      t.string :summary, limit: 500
      t.string :national_identity, limit: 300
      t.text :biography
      t.string :birth_date, limit: 10
      t.string :death_date, limit: 10
    end

    add_index :persons, :id, unique: true
    add_index :persons, :name
    add_index :persons, :id,   name:   :id_like, order: {name: :varchar_pattern_ops}
    add_index :persons, :name, name: :name_like, order: {name: :varchar_pattern_ops}
  end

  def self.down
  end
end
