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

      def render_error(status:, type:, code: nil)
        render json: {type: type}.tap {|json| json[:code] = code if code.present?}, status: status
      end

      def unprocessable_entity(code)
        render_error(status: :unprocessable_entity, type: 'invalid-request-error', code: code)
      end

      def not_found(code)
        render_error(status: :not_found, type: 'invalid-request-error', code: code)
      end

      def unauthorized(code)
        render_error(status: :unauthorized, type: 'authentication-error', code: code)
      end

      def internal_server_error(code)
        render_error(status: :internal_server_error, type: 'unexpected-error', code: code)
      end
    end
  end
end
