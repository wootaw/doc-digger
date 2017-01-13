module Restwoods
  class LineParser

    PICKS = { c: /\A\s*\*/, erlang: /\A\s*%/, perl: /\A\s*#/ }

    def initialize(str, clazz)
      @clazz = clazz
      pick = PICKS[clazz]
      @str = pick.nil? ? str : str.gsub(pick, '')
    end

    def parse
      parts = @str.strip.split(/\s+/)
      case parts[0]
      when "@doc"
        { type: :document, part: :main }.tap do |result|
          m = parts[1].match(/\((\w+)\)/)
          result[:data] = {
            summary: parts[(m.nil? ? 1 : 2)..(parts.length - 1)].join(" "),
            name: m.nil? ? nil : m[1]
          }
        end
      when "@doc_desc"
        {
          type: :document,
          part: :description,
          data: { text: parts[1].nil? ? nil : parts[1..(parts.length - 1)].join(" ") }
        }
      when "@res"
        {
          type: :resource,
          part: :main,
          data: { method: parts[1], route: parts[2], summary: parts[3..(parts.length - 1)].join(" ") }
        }
      when "@res_desc"
        {
          type: :resource,
          part: :description,
          data: { text: parts[1].nil? ? nil : parts[1..(parts.length - 1)].join(" ") }
        }
      else
        { type: :joint, text: @str }
      end
    end

    def start_space
      @start_space ||= @str.match(/\A\s*/)[0].length
    end

  end
end
