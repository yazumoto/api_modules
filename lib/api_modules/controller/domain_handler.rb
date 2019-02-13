module ApiModules
  module Controller
    module DomainHandler
      extend ActiveSupport::Concern

      def handle_domain_save(domain)
        if domain.save
          yield
        else
          render_domain_error domain
        end
      end
    end
  end
end
