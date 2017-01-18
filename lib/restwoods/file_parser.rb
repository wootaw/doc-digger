module Restwoods
  class FileParser

    LANGUAGES = {
      java:   [['/**', '*/'], /\A\.(js|jsx|c|cs|java|php?|ts|cpp|go|scala|dart)\Z/],
      ruby:   [['=begin', '=end'], /\A\.(rb)\Z/],
      perl:   [['#**', '#*'], /\A\.(perl|pl|pm)\Z/],
      python: [['"""', '"""'], /\A\.(py)\Z/],
      elixir: [['@restwoods """', '"""'], /\A\.(ex|exs?)\Z/],
      erlang: [['%{', '%}'], /\A\.(erl)\Z/],
      coffee: [['###', '###'], /\A\.(coffee)\Z/],
      lua:    [['--[[', ']]'], /\A\.(lua)\Z/]
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
              @source = false
              next
            end

            started = false if started && s.strip == LANGUAGES[lang][0][1]
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
          item = @results.last[:resources].last["#{@latest_command[:part]}s".to_sym].last
          process_descriptions(item, hash)
        else
          send("process_#{@latest_command[:type]}_command", hash, line_parser)
        end
      else
        send("process_#{hash[:type]}_command", hash, line_parser)
      end
    end

    def process_attributes(item, hash, parser)
      case hash[:part]
      when :state
        item[:state] = hash[:data]
      when nil
        process_descriptions(item, hash)
      else
        item.merge!(hash[:data])
      end

      unless hash[:type] == :joint
        set_latest_command(hash, parser)
      end
    end

    def process_document_command(hash, parser)
      @results << {} if @results.length == 0 || @results.last.has_key?(:summary) && hash[:part] == :main
      process_attributes(@results.last, hash, parser)
    end

    def process_resource_command(hash, parser)
      @results << {} if @results.length == 0
      @results.last[:resources] = [] unless @results.last.has_key?(:resources)

      item = case hash[:part]
      when :main
        @results.last[:resources] << {}
        @results.last[:resources].last
      when /\A(parameter|header|return|error)\Z/
        part = "#{hash[:part]}s".to_sym
        @results.last[:resources].last[part] = [] unless @results.last[:resources].last.has_key?(part)
        @results.last[:resources].last[part] << {}
        @results.last[:resources].last[part].last
      else
        @results.last[:resources].last
      end

      process_attributes(item, hash, parser)
    end

    def process_descriptions(item, hash)
      s = hash[:text].to_s.gsub(/\A\s{,#{@latest_command[:space] + 2}}/, '').rstrip
      linebreak = /(.*)(<=#)\Z/.match(s)
      s = linebreak[1].rstrip unless linebreak.nil?

      unless s.length == 0
        item[:descriptions] = [[]] unless item.has_key?(:descriptions)
        descs = item[:descriptions]

        if /\A\s*(#+|>|\-\s*|\d+\.|`{3})/ === s || @source
          descs.pop if descs.last.length == 0
          descs.push([s], [])
          @source = @source ^ (/\A\s*`{3}/ === s)
        else
          descs.last << s
          descs << [] unless linebreak.nil?
        end
      end
    end

    def set_latest_command(hash, parser)
      @latest_command = hash.select { |k, v| k != :data }
      @latest_command[:space] = parser.indentation
    end

    def check_lang
      LANGUAGES.each { |l, options| return l if options[1] === @ext }
      nil
    end

  end
end
