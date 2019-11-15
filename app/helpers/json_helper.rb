module JsonHelper
  def valid_json?(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
  end

  def parse_json_for_tooltip(hash, iteration = 0, request = '', settings = '')
    output = ""
    iteration += 1
    hash.each do |key, value|
      padding = "padding-left: #{iteration - 1}em;"
      if value.is_a?(Hash)
        output += "<span class='tooltip-info' style='#{padding}'><strong>#{key.capitalize()}:</strong></span><br />"
        output += parse_json_for_tooltip(value,iteration)
      elsif value.is_a?(Array)
        output += "<span class='tooltip-info' style='#{padding}'><strong>#{key.capitalize()}:</strong></span>"
        value.each do |value|
          if value.is_a?(String) then
            output += "<span class='tooltip-info' style='#{padding}'>#{value}</span>"
          else
            output += parse_json_for_tooltip(value,iteration-1)
          end
        end
      else
        if iteration > 1
          output += "<span class='tooltip-info' style='#{padding}'><strong>#{key.capitalize()}</strong><br>#{value}</span>"
        else
          if key != '' && value != ''
            output += "<div class='card-block mb-2'><strong class='possible-table-key'>#{key}</strong><span class='float-right'>#{value}</span></div>"
          elsif key != '' && value == ''
            output += "<div class='card-block mb-2'><strong class='possible-table-key'>#{key}</strong><span class='float-right' style='opacity: 0.2'>null</span></div>"
          end
        end
      end
    end
    return output
  end
end
