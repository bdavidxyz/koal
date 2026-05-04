module Myaccount::Errors::Index
  class Service < Servus::Base
    REQUEST_ID_PATTERN = /\A\[(?<request_id>[^\]]+)\]/.freeze
    ERROR_PATTERNS = [
      /\bstatus=5\d{2}\b/i,
      /\bCompleted 5\d{2}\b/i,
      /uncaught exception:/i
    ].freeze

    def initialize(log_path: Rails.root.join("log", "#{Rails.env}.log"))
      @log_path = Pathname.new(log_path)
    end

    def call
      success(
        request_ids: error_request_ids,
        log_path: @log_path.to_s,
        environment: Rails.env
      )
    end

    private
      def error_request_ids
        return [] unless @log_path.exist?

        request_ids_by_last_match = {}

        File.foreach(@log_path).with_index do |line, index|
          next unless error_line?(line)

          request_id = extract_request_id(line)
          next if request_id.blank?

          request_ids_by_last_match[request_id] = index
        end

        request_ids_by_last_match
          .sort_by { |_request_id, index| -index }
          .map(&:first)
      end

      def error_line?(line)
        ERROR_PATTERNS.any? { |pattern| pattern.match?(line) }
      end

      def extract_request_id(line)
        line.match(REQUEST_ID_PATTERN)&.[](:request_id)
      end
  end
end
