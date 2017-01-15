module Restwoods
  class FileParser

    LANGUAGES = {
      java:   [['/**', '*/'], [".js", ".c", ".java", ".php", ".ts"]],
      ruby:   [['=begin', '=end'], [".rb"]],
      perl:   [['#**', '#*'], [".perl", ".pl", ".pm"]],
      python: [['"""', '"""'], [".py"]],
      elixir: [['@restwoods """', '"""'], [".ex", ".exs"]],
      erlang: [['%{', '%}'], [".erl"]],
      coffee: [['###', '###'], [".coffee"]]
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

    def lang
      @flang ||= check_lang
    end

    def parse
      if @type == "file" && !lang.nil?
        File.open(@name, "r") do |f|
          started = false
          f.each_line do |s|
            if s.strip == LANGUAGES[lang][0][0]
              started = true
              next
            end

            if started && s.strip == LANGUAGES[lang][0][1]
              started = false
              joint_descriptions
            end
            process_line(s) if started
          end
        end
      end
      @results
    end

    protected

    def process_line(str)
      line_parser = Restwoods::LineParser.new(str, lang)
      hash = line_parser.parse
      if hash[:type] == :joint
        case @latest_command[:part]
        when :parameter
          process_parameter_command(hash, line_parser)
        else
          send("process_#{@latest_command[:type]}_command", hash, line_parser)
        end unless @latest_command.nil?
      else
        joint_descriptions
        send("process_#{hash[:type]}_command", hash, line_parser)
      end
    end

    def joint_descriptions
      return if @latest_command.nil?
      descs = case @latest_command[:type]
      when :document
        @results.last[:descriptions]
      when :resource
        case @latest_command[:part]
        when :parameter
          @results.last[:resources].last[:parameters].last[:descriptions]
        else
          @results.last[:resources].last[:descriptions]
        end
      end
      descs[-1] = descs.last.join(" ") unless descs.nil?
      @latest_command = nil
    end

    def set_latest_command(hash, parser)
      @latest_command = hash.select { |k, v| k != :data }
      @latest_command[:space] = parser.start_space
    end

    def process_command(array, hash, parser)
      array << {} if array.length == 0

      case hash[:part]
      when :main
        array << {} if array.last.has_key?(:summary)
        array.last.merge!(hash[:data])
      when :description
        set_latest_command(hash, parser)

        array.last[:descriptions] = [] unless array.last.has_key?(:descriptions)
        array.last[:descriptions] << []
        array.last[:descriptions].last << hash[:data][:text] unless hash[:data][:text].nil?
      else
        s = hash[:text].to_s.gsub(/\A\s{,#{@latest_command[:space] + 2}}/, '').rstrip
        array.last[:descriptions].last << s unless s.length == 0
      end
    end

    def process_document_command(hash, parser)
      process_command(@results, hash, parser)
    end

    def process_resource_command(hash, parser)
      @results << {} if @results.length == 0
      @results.last[:resources] = [] unless @results.last.has_key?(:resources)
      if hash[:part] == :parameter
        process_parameter_command(hash, parser)
      else
        process_command(@results.last[:resources], hash, parser)
      end
    end

    def process_parameter_command(hash, parser)
      @results << { resources: [] } if @results.length == 0
      res = @results.last[:resources].last

      if hash[:type] == :joint
        res[:parameters].last[:descriptions] = [[]] unless res[:parameters].last.has_key?(:descriptions)
        # res[:parameters].last[:descriptions] << []
        process_command(res[:parameters], hash, parser)
      else
        res[:parameters] = [] unless res.has_key?(:parameters)
        res[:parameters] << hash[:data]
        set_latest_command(hash, parser)
      end
    end

    def check_lang
      LANGUAGES.each { |l, options| return l if options[1].include?(@ext) }
      nil
    end

  end
end
