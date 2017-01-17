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
        return if @latest_command.nil?
        if [:parameter, :header, :return, :error].include?(@latest_command[:part])
          process_resource_attributes(hash, line_parser, "#{@latest_command[:part]}s".to_sym)
        else
          send("process_#{@latest_command[:type]}_command", hash, line_parser)
        end
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
        if [:parameter, :header, :return, :error].include?(@latest_command[:part])
          @results.last[:resources].last["#{@latest_command[:part]}s".to_sym].last[:descriptions]
        else
          @results.last[:resources].last[:descriptions]
        end
      end
      descs[-1] = descs.last.join(" ") if !descs.nil? && descs.last.is_a?(Array)
      @latest_command = nil
    end

    def set_latest_command(hash, parser)
      @latest_command = hash.select { |k, v| k != :data }
      @latest_command[:space] = parser.indentation
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
        unless s.length == 0
          descs = array.last[:descriptions]
          if /\A\s*((#+)|>|(\-\s)|(\d+\.))/ === s
            descs[-1] = descs.last.join(" ") if descs.last.is_a?(Array)
            descs << [] if descs.last.length > 0
            descs[-1] = s
          else
            array.last[:descriptions].last << s
          end
        end
      end
    end

    def process_document_command(hash, parser)
      process_command(@results, hash, parser)
    end

    def process_resource_command(hash, parser)
      @results << {} if @results.length == 0
      @results.last[:resources] = [] unless @results.last.has_key?(:resources)
      if [:parameter, :header, :return, :error].include?(hash[:part])
        process_resource_attributes(hash, parser, "#{hash[:part]}s".to_sym)
      else
        process_command(@results.last[:resources], hash, parser)
      end
    end

    # def process_parameter_command(hash, parser)
    #   process_resource_attributes(hash, parser, :parameters)
    # end
    #
    # def process_header_command(hash, parser)
    #   process_resource_attributes(hash, parser, :headers)
    # end

    def process_resource_attributes(hash, parser, attr)
      @results << { resources: [] } if @results.length == 0
      res = @results.last[:resources].last

      if hash[:type] == :joint
        res[attr].last[:descriptions] = [[]] unless res[attr].last.has_key?(:descriptions)
        # res[:parameters].last[:descriptions] << []
        process_command(res[attr], hash, parser)
      else
        res[attr] = [] unless res.has_key?(attr)
        res[attr] << hash[:data]
        set_latest_command(hash, parser)
      end
    end

    def check_lang
      LANGUAGES.each { |l, options| return l if options[1].include?(@ext) }
      nil
    end

  end
end
