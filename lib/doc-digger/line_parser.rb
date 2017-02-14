module DocDigger
  class LineParser

    PICKS = { java: /\A\s*\*/, erlang: /\A\s*%/, perl: /\A\s*#/ }
    COMMANDS = /\A@(doc(\_state)?|res(\_(param|response|state|bind))?|cmd\_(def|use))\Z/
    PARAMETER_LOCATIONS = /\Apath|query|header|form|body|cookie\Z/
    RESPONSE_LOCATIONS = /\Aheader|body\Z/

    def initialize(str, clazz)
      @clazz = clazz
      pick = PICKS[clazz]
      @str = pick.nil? ? str : str.gsub(pick, '')
    end

    def parse
      parts = @str.strip.split(/\s+/)
      command = parts[0].to_s.match(COMMANDS)
      if command.nil? || command[1].nil?
        { type: :joint, text: @str }
      else
        send(command[1], parts[1..-1], command)
      end
    end

    def indentation
      @indentation ||= @str.match(/\A\s*/)[0].length
    end

    protected

    def cmd(args, cmd)
      { type: :cmd, part: cmd[1].split("_")[1].to_sym, data: { name: args[0] } }
    end

    def doc(args, _cmd)
      { type: :doc, part: :main, data: {} }.tap do |result|
        m = args[0].match(/\((\w+)\)/)
        result[:data][:summary] = args[[m].compact.length..-1].join(" ")
        result[:data][:name]    = m[1] unless m.nil?
      end
    end

    def res(args, _cmd)
      {
        type: :res,
        part: :main,
        data: { method: args[0], path: args[1], summary: args[2..-1].join(" ") }
      }
    end

    def res_bind(args, _cmd)
      { type: :res, part: :bind, data: {} }.tap do |result|
        m = args[0].match(/\((param|header|return|error)\)/)
        result[:data][:scope]   = m[1] unless m.nil?
        result[:data][:command] = args[[m].compact.length]
        result[:data][:vars]    = args[([m].compact.length + 1)..-1]
      end
    end

    def state(args, cmd)
      {
        type: cmd[1].split("_")[0].to_sym,
        part: :state,
        data: { name: args[0], summary: args[1..-1].join(" ") }
      }
    end

    def analyze_arguments(args)
      { group: args[0].to_s.match(/\((.+)\)/) }.tap do |r|
        r[:type]    = (r[:group].nil? ? args[0] : args[1]).to_s.match(/\{(.+)\}/)
        r[:names]   = args[[r[:group], r[:type]].compact.length].to_s
        r[:name]    = r[:names].match(/\A\[(.+)\]\Z/)
        r[:default] = (r[:name].nil? ? r[:names] : r[:name][1]).split("=")
        r[:parent]  = r[:default][0].split(".")
      end
    end

    def res_io(args, cmd)
      { type: :res, part: cmd[4].to_sym, data: {} }.tap do |result|
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

        case result[:part]
        when :param
          location = (r[:group] || [])[1]
          result[:data][:location]  = PARAMETER_LOCATIONS === location ? location : 'query'
          result[:data][:required]  = location == "path" || r[:name].nil?
          result[:data][:default]   = r[:default][1] if r[:default].length == 2
          result[:data][:name]      = r[:parent].length == 1 ? r[:default][0] : r[:parent][-1]
        when :response
          location = (r[:group] || [nil, 'body'])[1].split('=')
          result[:data][:group]     = location[1] if location.length > 1
          result[:data][:location]  = RESPONSE_LOCATIONS === location[0] ? location[0] : 'body'
          result[:data][:name]      = r[:parent].length == 1 ? r[:names] : r[:parent][-1]
        end

        result[:data][:parent]    = r[:parent][0..-2] if r[:parent].length > 1
        result[:data][:summary]   = args[([r[:group], r[:type]].compact.length + 1)..-1].join(' ')
      end
    end

    alias_method :res_param,    :res_io
    alias_method :res_response, :res_io

    alias_method :doc_state,  :state
    alias_method :res_state,  :state

    alias_method :cmd_def, :cmd
    alias_method :cmd_use, :cmd
  end
end
