module Restwoods
  class LineParser

    PICKS = { java: /\A\s*\*/, erlang: /\A\s*%/, perl: /\A\s*#/ }
    AMAP  = { param: :parameter, header: :header, ok: :return, error: :error }

    def initialize(str, clazz)
      @clazz = clazz
      pick = PICKS[clazz]
      @str = pick.nil? ? str : str.gsub(pick, '')
    end

    def parse
      parts = @str.strip.split(/\s+/)
      command = parts[0].to_s.match(/\A@(doc|res(\_(param|header|ok|error|depr))?)\Z/)
      if command.nil? || command[1].nil?
        { type: :joint, text: @str }
      else
        send(command[1], parts[1..-1])
      end
    end

    def indentation
      @indentation ||= @str.match(/\A\s*/)[0].length
    end

    protected

    AMAP.each do |k, v|
      class_eval <<-CODE
        def res_#{k}(args)
          res_io(args, :#{v})
        end
      CODE
    end

    def doc(args)
      { type: :document, part: :main }.tap do |result|
        m = args[0].match(/\((\w+)\)/)
        result[:data] = {
          summary: args[(m.nil? ? 0 : 1)..-1].join(" "),
          name: m.nil? ? nil : m[1]
        }
      end
    end

    def res(args)
      {
        type: :resource,
        part: :main,
        data: { method: args[0], route: args[1], summary: args[2..-1].join(" ") }
      }
    end

    def analyze_arguments(args)
      { group: args[0].to_s.match(/\((\w+)\)/) }.tap do |r|
        r[:type]    = (r[:group].nil? ? args[0] : args[1]).to_s.match(/\{(.+)\}/)
        r[:names]   = args[[r[:group], r[:type]].compact.length].to_s
        r[:name]    = r[:names].match(/\A\[(.+)\]\Z/)
        r[:default] = (r[:name].nil? ? r[:names] : r[:name][1]).split("=")
        r[:parent]  = r[:default][0].split(".")
      end
    end

    def res_io(args, part)
      { type: :resource, part: part, data: {} }.tap do |result|
        r = analyze_arguments(args)
        unless r[:type].nil?
          options = r[:type][1].split("=")
          array = options[0].match(/(\w+)(\[\])?\Z/)

          result[:data][:options] = options[1].split(",") if options.length == 2
          unless array.nil?
            result[:data][:array] = !array[2].nil?
            result[:data][:type]  = array[1]
          end
        end
        result[:data][:group]     = r[:group][1] unless r[:group].nil?
        result[:data][:required]  = r[:name].nil?
        result[:data][:default]   = r[:default][1] if r[:default].length == 2
        result[:data][:parent]    = r[:parent][-2] if r[:parent].length > 1
        result[:data][:name]      = r[:parent].length == 1 ? r[:default][0] : r[:parent][-1]
        result[:data][:summary]   = args[([r[:group], r[:type]].compact.length + 1)..-1].join(' ')
      end
    end

  end
end
