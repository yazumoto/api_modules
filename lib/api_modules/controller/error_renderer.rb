module ApiModules
  module Controller
    module ErrorRenderer
      extend ActiveSupport::Concern

      def render_domain_error(domain)
        status = domain._error_status&.to_sym || :unprocessable_entity
        type = domain._error_type || 'invalid-request-error'
        code = domain._error_code
        # is_error は エラーになっているかを示すだけのものなので削除する
        domain.errors.delete(:is_error)
        error = {type: type}.tap do |err|
          err[:code] = code if code.present?
          err[:params] = domain.errors unless domain.errors.empty?
        end
        render json: error, status: status
      end

      def render_error(status:, type:, code: nil, params: nil)
        render status: status, json: { type: type }.tap do |json|
          json[:code] = code if code.present?
          json[:params] = params if params.present?
        end
      end

      def unprocessable_entity(code: nil, params: nil)
        render_error(status: :unprocessable_entity, type: 'invalid-request-error', code: code, params: params)
      end

      def not_found(code: nil, params: nil)
        render_error(status: :not_found, type: 'invalid-request-error', code: code, params: params)
      end

      def unauthorized(code: nil, params: nil)
        render_error(status: :unauthorized, type: 'authentication-error', code: code, params: params)
      end

      def internal_server_error(code: nil, params: nil)
        render_error(status: :internal_server_error, type: 'unexpected-error', code: code, params: params)
      end
    end
  end
end
