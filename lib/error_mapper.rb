# app/lib/error_mapper.rb
class ErrorMapper
  class << self
    def raise_from_status!(status, message = nil)
      case normalize(status)
      when 400
        raise ActionController::BadRequest, message
      when 401
        raise UnauthorizedError, message
      when 403
        raise ForbiddenError, message
      when 404
        raise ActiveRecord::RecordNotFound, message
      when 422
        raise UnprocessableEntityError, message
      else
        raise StandardError, message || "HTTP #{status}"
      end
    end

    private

    def normalize(status)
      Rack::Utils.status_code(status)
    end
  end
end
