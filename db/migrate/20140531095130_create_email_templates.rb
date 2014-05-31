class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :email_templates do |t|
      t.string :name
      t.text :body, default: 'Email body not set'

      t.timestamps
    end
    add_index :email_templates, :name, unique: true
  end
end
