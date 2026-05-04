module Myaccount::Errors::Show
  class Service < Servus::Base
    schema do
      required(:request_id).filled(:string)
    end

    def initialize(request_id:, log_path: Rails.root.join("log", "#{Rails.env}.log"))
      @request_id = request_id
      @log_path = Pathname.new(log_path)
    end

    def call
      return failure("Log file not found", type: NotFoundError) unless @log_path.exist?

      lines = log_lines_for_request_id

      return failure("No log lines found for request id", type: NotFoundError) if lines.empty?

      success(
        request_id: @request_id,
        lines: lines
      )
    end

    private

      SOLID_ERRORS_PATTERN = /(SolidErrors|solid_errors)/i.freeze
      TRANSACTION_PATTERN = /\bTRANSACTION\b/i.freeze

      def log_lines_for_request_id
        request_lines = []

        File.foreach(@log_path).with_index do |line, index|
          next unless line_matches_request_id?(line)

          request_lines << { index: index, content: line.chomp }
        end

        request_lines.reject.with_index do |entry, position|
          solid_errors_line?(entry[:content]) || solid_errors_transaction_line?(request_lines, position)
        end
      end

      def line_matches_request_id?(line)
        line.include?("[#{@request_id}]")
      end

      def solid_errors_line?(line)
        SOLID_ERRORS_PATTERN.match?(line)
      end

      def solid_errors_transaction_line?(request_lines, position)
        return false unless TRANSACTION_PATTERN.match?(request_lines[position][:content])

        neighboring_lines(request_lines, position).any? { |line| solid_errors_line?(line[:content]) }
      end

      def neighboring_lines(request_lines, position)
        [
          request_lines[position - 1],
          request_lines[position + 1]
        ].compact
      end
  end
end
