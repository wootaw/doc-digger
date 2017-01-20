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
    MARKDOWNS = /\A\s*(#+|>|\-\s*|\d+\.|`{3})/

    attr_reader :document_name

    def initialize(filename)
      @name = filename
      @type = File.ftype(filename)
      @ext = File.extname(@name)
      @document_name = File.basename(filename, @ext)
    end

    def lang
      @flang ||= check_lang
    end

    def results
      @results ||= parse
    end

    def parse
      @results = []
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
      end if @type == "file" && !lang.nil?
      @results
    end

    protected

    def process_line(str)
      line_parser = Restwoods::LineParser.new(str, lang)
      hash = line_parser.parse
      if hash[:type] == :joint
        return if @recent_command.nil?
        process_descriptions(branch(@recent_command), hash)
      else
        branch(hash, true).merge!(hash[:data])
        @recent_command = hash.select { |k| k != :data }
        @recent_command[:space] = line_parser.indentation
        @linebreak = false
      end
    end

    def branch(command, initial=false)
      @results << {} if initial && (@results.length == 0 || command[:type] == :doc && command[:part] == :main)
      item = @results.last

      if command[:type] == :res
        if initial
          item[:resources] = [] unless item.has_key?(:resources)
          item[:resources] << {} if command[:part] == :main
        end
        item = item[:resources].last
      end

      case command[:part]
      when :state
        item[:state] = {} if initial && !item.has_key?(:state)
        item = item[:state]
      when /\A(param|header|return|error|bind)\Z/
        part = "#{command[:part]}s".to_sym
        if initial
          item[part] = [] unless item.has_key?(part)
          item[part] << {}
        end
        item = item[part].last
      end
      item
    end

    def process_descriptions(item, hash)
      text = hash[:text].to_s.gsub(/\A\s{,#{@recent_command[:space] + 2}}/, '').rstrip
      if text.length == 0
        @linebreak = true
        return
      end
      markdown = MARKDOWNS === text || @source
      @source ^= /\A\s*`{3}/ === text if markdown

      item[:descriptions] = [[]] unless item.has_key?(:descriptions)
      item[:descriptions] << [] if @linebreak || markdown
      item[:descriptions].last << text
      @linebreak = markdown
    end

    def check_lang
      LANGUAGES.each { |l, options| return l if options[1] === @ext }
      nil
    end

  end
end
