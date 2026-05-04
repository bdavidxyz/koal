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
        request_ids: request_ids_for(source),
        log_path: @log_path.to_s,
        environment: Rails.env,
        source: source,
        source_label: source_label_for(source),
        source_location: source_location_for(source)
      )
    end

    private
      def request_ids_for(source)
        case source
        when :solid_errors then error_request_ids_from_occurrences
        else error_request_ids_from_log
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

      def error_request_ids_from_log
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

      def error_request_ids_from_occurrences
        request_ids_by_last_seen_at = {}

        occurrences.each do |occurrence|
          request_id = occurrence_request_id(occurrence)
          next if request_id.blank?

          request_ids_by_last_seen_at[request_id] = occurrence.created_at
        end

        request_ids_by_last_seen_at
          .sort_by { |_request_id, created_at| -created_at.to_f }
          .map(&:first)
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
  end
end
