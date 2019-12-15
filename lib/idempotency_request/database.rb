module IdempotencyRequest
  class Database
    IDEMPOTENCY_HEADER = 'HTTP_IDEMPOTENCY_KEY'.freeze

    def initialize app
      @app = app
    end

    def call env
      dup._call(env)
    end

    def _call(env)
      idempotency_key = env[IDEMPOTENCY_HEADER]
      puts env

      if idempotency_key.present?
        action = ::IdempotencyAction.usable.find_by(idempotency_key: idempotency_key)

        if action.present?
          status = action.status
          headers = action.headers.present? ? ActiveSupport::JSON.decode(action.headers) : {}
          response = action.body.present? ? [ActiveSupport::JSON.decode(action.body)] : []
        else
          idempotent_action = ::IdempotencyAction.create!(
            idempotency_key: idempotency_key,
            status: 202
          )
          status, headers, response = @app.call(env)
          body = response.respond_to?(:body) ? response.body : nil

          idempotent_action.update(
            status: status,
            body: body.to_json,
            headers: headers.to_json
          )
        end

        [status, headers, response]
      else
        @app.call(env)
      end
    end
  end
end
