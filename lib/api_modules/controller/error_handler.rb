module ApiModules
  module Controller
    module ErrorHandler
      extend ActiveSupport::Concern
      include ActiveSupport::Rescuable

      included do
        rescue_from Exception, with: :server_error unless Rails.env.test?
      end

      private

      def server_error(exception = nil)
        before_server_error(exception)
        render json: { type: 'unexpected_error' }, status: :internal_server_error
      end

      # Implement before_server_error if you want to add implementation before server error
      def before_server_error(exception); end
    end
  end
end
