module ApiModules
  module Helper
    module Partialize
      def partialize(json, instance)
        return if instance.nil?
        klass = instance.class.name.underscore
        json.partial! partial_path(klass), klass.split('/').last.intern => instance
      end

      private

      # @return [String] バーチャルパスを基に組み立てたviewパーシャルパス
      # @example
      #  `sample/api/v1/books/show` => `sample/api/v1/models/book`
      def partial_path(klass)
        "#{_path}models/#{klass}"
      end

      def _path
        @path ||= @virtual_path.gsub(/[^\/]*\/[^\/]*$/o, '')
      end
    end
  end
end
