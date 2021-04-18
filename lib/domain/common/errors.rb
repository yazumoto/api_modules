module Domain
  module Common
    class Errors < ActiveModel::Errors
      def add_model_error(model, error_prefix = nil)
        model.errors.each do |key, val|
          add("#{error_prefix}#{key}", val)
        end
      end
    end
  end
end
