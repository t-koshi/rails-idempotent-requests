class CreateIdempotencyActions < ActiveRecord::Migration[6.0]
  def change
    create_table :idempotency_actions do |t|
      t.string :idempotency_key, null: false, index: { unique: true }
      t.integer :status
      t.text :body
      t.text :headers

      t.timestamps
    end
  end
end
