class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  def verify_idempotency
    render json: { result: SecureRandom.uuid }
  end
end
