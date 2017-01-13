module Restwoods
  class FileParser

    SUPPORT_CLASSES = {
      c: {
        block: ['/**', '*/'],
        ext: [".js", ".c", ".java", ".php", ".ts"]
      },
      ruby: {
        block: ['=begin', '=end'],
        ext: [".rb"]
      },
      python: {
        block: ['"""', '"""'],
        ext: [".py"]
      },
      elixir: {
        block: ['@restwoods """', '"""'],
        ext: [".ex", ".exs"]
      },
      perl: {
        block: ['#**', '#*'],
        ext: [".perl", ".pl", ".pm"]
      },
      erlang: {
        block: ['%{', '%}'],
        ext: [".erl"]
      },
      coffee: {
        block: ['###', '###'],
        ext: [".coffee"]
      }
    }

    attr_reader :document_name
    attr_reader :results

    def initialize(filename)
      @name = filename
      @type = File.ftype(filename)
      @ext = File.extname(@name)
      @document_name = File.basename(filename, @ext)
      @results = []
    end

    def current_class
      @fclass ||= check_class
    end

    def parse
      if @type == "file" && !current_class.nil?
        File.open(@name, "r") do |f|
          started = false
          f.each_line do |s|
            if s.strip == SUPPORT_CLASSES[current_class][:block][0]
              started = true
              next
            end
            started = false if started && s.strip == SUPPORT_CLASSES[current_class][:block][1]
            process_line(s) if started
          end
        end
      end
      @results
    end

    protected

    def process_line(str)
      line_parser = Restwoods::LineParser.new(str, current_class)
      hash = line_parser.parse
      case hash[:type]
      when :document
        process_document_command(hash, line_parser)
      when :resource
        process_resource_command(hash, line_parser)
      when :joint
        process_document_command(hash, line_parser) if @latest_command[:type] == :document
        process_resource_command(hash, line_parser) if @latest_command[:type] == :resource
      end
    end

    def process_command(array, hash, parser)
      array << {} if array.length == 0

      case hash[:part]
      when :main
        array << {} if array.last.has_key?(:summary)
        array.last.merge!(hash[:data])
      when :description
        @latest_command = hash.select { |k, v| k != :data }
        @latest_command[:space] = parser.start_space

        array.last[:descriptions] = [] unless array.last.has_key?(:descriptions)
        array.last[:descriptions] << []
        array.last[:descriptions].last << hash[:data][:text] unless hash[:data][:text].nil?
      else
        s = hash[:text].gsub(/\A\s{,#{@latest_command[:space] + 2}}/, '')
        array.last[:descriptions].last << s.rstrip
      end
    end

    def process_document_command(hash, parser)
      process_command(@results, hash, parser)
    end

    def process_resource_command(hash, parser)
      @results << { resources: [] } if @results.length == 0
      @results.last[:resources] = [] unless @results.last.has_key?(:resources)
      process_command(@results.last[:resources], hash, parser)
    end

    def check_class
      SUPPORT_CLASSES.each do |c, options|
        return c if options[:ext].include?(@ext)
      end
      nil
    end

  end
end
