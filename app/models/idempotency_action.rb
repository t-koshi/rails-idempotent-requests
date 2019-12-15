class IdempotencyAction < ApplicationRecord
  USABLE_PERIOD = 1.days
  scope :usable, ->() { where("created_at >= ?", Time.zone.now - USABLE_PERIOD) }
end
