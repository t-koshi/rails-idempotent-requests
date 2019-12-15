Rails.application.routes.draw do
  post 'verify_idempotency', to: 'application#verify_idempotency'
end
