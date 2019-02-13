module Domain
  module Common
    class Errors < ActiveModel::Errors
      def add_model_error(model)
        model.errors.each do |key, val|
          add(key, val)
        end
      end
    end
  end
end
