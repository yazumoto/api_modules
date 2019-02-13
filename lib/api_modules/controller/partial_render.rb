module ApiModules
  module Controller
    module PartialRender
      extend ActiveSupport::Concern

      def partialize(instance, options = {})
        status = options[:status] || :ok
        path = options[:path] || model_path
        klass = instance.class.name.underscore
        render partial: partial_path(klass, path), locals: { klass.intern => instance }, status: status
      end

      private

      def partial_path(klass, path)
        "#{path}/models/#{klass}"
      end

      # @return [String] クラスのモジュール情報を元にパスを作成
      def model_path
        @model_path ||= self.class.name.underscore.gsub(%r{[^\/]*$}o, '')
      end
    end
  end
end
