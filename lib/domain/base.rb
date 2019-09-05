module Domain
  class Base
    include ActiveModel::Model
    # 現状、new以外で代入された値については変化があったかどうかわからない。
    # Dirtyと組み合わせることで良い感じになる可能性があるのでこのコメントを残しておきます
    # include ActiveModel::Dirty

    attr_accessor :_error_status, :_error_type, :_error_code, :is_error, :_data, :_params, :_current_user

    def self.attr_accessor(*vars)
      super(*vars)
      vars.each do |var|
        define_method("has_#{var}?") { @_params&.has_key?(var) }
      end
    end

    def initialize(params = {})
      super(params)
      @_params = params
    end

    def transaction
      result = ActiveRecord::Base.transaction do
        yield
        true
      end
      result || false
    end

    def create_params(*attr_names)
      {}.tap do |params|
        attr_names.each do |name|
          params[name] = send(name) if send("has_#{name}?")
        end
      end
    end

    def update_data(data, options)
      @_data = data
      if @_data.update(options)
        true
      else
        errors.add_model_error(@_data)
        false
      end
    end

    def update_data!(data, options)
      update_data(data, options) || raise(ActiveRecord::Rollback)
    end

    def save_data(data)
      @_data = data
      if @_data.save
        true
      else
        errors.add_model_error(@_data)
        false
      end
    end

    def save_data!(data)
      save_data(data) || raise(ActiveRecord::Rollback)
    end

    def set_errors(status: nil, type: nil, code: nil, params: nil)
      @_error_status = status if status.present?
      @_error_type = type if type.present?
      @_error_code = code if code.present?
      errors.add(:is_error, 'error')
      params.each { |key, value| errors.add(key, value) } if params.present?
      false
    end

    def unauthorized(code: nil, params: nil)
      set_errors(
        status: :unauthorized,
        type: 'authentication-error',
        code: code,
        params: params
      )
    end

    def not_found(code: nil)
      set_errors(
        status: :not_found,
        type: 'invalid-request-error',
        code: code
      )
    end

    def unprocessable_entity(code: nil, params: nil)
      set_errors(
        status: :unprocessable_entity,
        type: 'invalid-request-error',
        code: code,
        params: params
      )
    end

    def internal_server_error(code)
      set_errors(
        status: :internal_server_error,
        type: 'unexpected-error',
        code: code,
        params: params
      )
    end

    def errors
      @errors ||= Domain::Common::Errors.new(self)
    end
  end
end
