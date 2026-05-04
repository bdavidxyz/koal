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

      SOLID_ERRORS_PATTERN = /SolidErrors/i.freeze

      def log_lines_for_request_id
        results = []

        File.foreach(@log_path).with_index do |line, index|
          next unless line_matches_request_id?(line)
          next if solid_errors_line?(line)

          results << { index: index, content: line.chomp }
        end

        results
      end

      def line_matches_request_id?(line)
        line.include?("[#{@request_id}]")
      end

      def solid_errors_line?(line)
        SOLID_ERRORS_PATTERN.match?(line)
      end
  end
end
