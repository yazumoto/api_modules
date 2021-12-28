module Domain
  module Common
    class Errors < ActiveModel::Errors
      def add_model_error(model, error_prefix = nil)
        model.errors.each do |error|
          add("#{error_prefix}#{error.attribute}", error.message)
        end
      end
    end
  end
end
