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

    attr_reader :document_alias
    attr_reader :results

    def initialize(filename)
      @name = filename
      @type = File.ftype(filename)
      @ext = File.extname(@name)
      @document_alias = File.basename(filename, @ext)
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
            if s.strip == SUPPORT_CLASSES[current_class][0]
              started = true
              next
            end
            started = false if started && s.strip == SUPPORT_CLASSES[current_class][1]
            process_line(s) if started
          end
        end
      end
      @results
    end

    protected

    def process_line(str)
      line_parser = Restwoods::LineParser.new(s, current_class)
      hash = line_parser.parse
      case hash[:type]
      when :document
        
      end
    end

    def check_class
      SUPPORT_CLASSES.each do |c, options|
        return c if options[:ext].include?(@ext)
      end
      nil
    end

  end
end
