module Myaccount::Errors::Index
  class Service < Servus::Base
    REQUEST_ID_PATTERN = /\A\[(?<request_id>[^\]]+)\]/.freeze
    ERROR_PATTERNS = [
      /\bstatus=5\d{2}\b/i,
      /\bCompleted 5\d{2}\b/i,
      /uncaught exception:/i
    ].freeze

    def initialize(log_path: Rails.root.join("log", "#{Rails.env}.log"), source: nil, occurrences: nil)
      @log_path = Pathname.new(log_path)
      @source = source&.to_sym
      @occurrences = occurrences
    end

    def call
      source = selected_source

      success(
        errors: errors_for(source),
        log_path: @log_path.to_s,
        environment: Rails.env,
        source: source,
        source_label: source_label_for(source),
        source_location: source_location_for(source)
      )
    end

    private
      def errors_for(source)
        case source
        when :solid_errors then errors_from_occurrences
        else errors_from_log
        end
      end

      def selected_source
        @source || default_source
      end

      def default_source
        production_stdout_logging? ? :solid_errors : :log_file
      end

      def production_stdout_logging?
        Rails.env.production? && ENV.fetch("RAILS_LOG_TO_STDOUT", "false") == "true"
      end

      def source_label_for(source)
        case source
        when :solid_errors then "Solid Errors occurrences"
        else "#{Rails.env} log file"
        end
      end

      def source_location_for(source)
        case source
        when :solid_errors then "solid_errors_occurrences.context.request_id"
        else @log_path.to_s
        end
      end

      def errors_from_log
        return [] unless @log_path.exist?

        error_request_ids = {}
        all_lines = []

        File.foreach(@log_path).with_index do |line, index|
          all_lines << { line: line, index: index }
          next unless error_line?(line)

          request_id = extract_request_id(line)
          next if request_id.blank?

          error_request_ids[request_id] = index
        end

        error_request_ids.map do |request_id, last_index|
          request_lines = all_lines.select { |l| extract_request_id(l[:line]) == request_id }
          timestamp = extract_timestamp_from_lines(request_lines)
          error_name = extract_error_name_from_lines(request_lines)

          {
            request_id: request_id,
            timestamp: timestamp,
            error_name: error_name
          }
        end.sort_by { |error| -error_request_ids[error[:request_id]] }
      end

      def errors_from_occurrences
        errors_by_request_id = {}

        occurrences.each do |occurrence|
          request_id = occurrence_request_id(occurrence)
          next if request_id.blank?

          errors_by_request_id[request_id] = {
            request_id: request_id,
            timestamp: occurrence.created_at,
            error_name: occurrence.error&.class_name || "Unknown Error"
          }
        end

        errors_by_request_id
          .values
          .sort_by { |error| -error[:timestamp].to_f }
      end

      def occurrence_request_id(occurrence)
        context = occurrence.respond_to?(:context) ? occurrence.context : nil
        return if context.blank?

        context["request_id"] || context[:request_id]
      end

      def default_occurrences
        return [] unless defined?(SolidErrors::Occurrence)

        SolidErrors::Occurrence.order(created_at: :desc)
      rescue ActiveRecord::ConnectionNotEstablished, ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
        []
      end

      def occurrences
        @occurrences || default_occurrences
      end

      def error_line?(line)
        ERROR_PATTERNS.any? { |pattern| pattern.match?(line) }
      end

      def extract_request_id(line)
        line.match(REQUEST_ID_PATTERN)&.[](:request_id)
      end

      def extract_timestamp_from_lines(lines)
        lines.each do |l|
          match = l[:line].match(/\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}(\.\d+)?/)
          return match[0] if match
        end
        nil
      end

      def extract_error_name_from_lines(lines)
        lines.each do |l|
          line = l[:line]
          # Look for error patterns like "Caused by: NoMethodError" or "ActionView::Template::Error"
          match = line.match(/(?:Caused by:\s*|^)(\w*(?:Error|Exception))\b/)
          return match[1] if match
        end
        "Unknown Error"
      end
  end
end
