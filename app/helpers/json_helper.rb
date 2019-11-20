module JsonHelper
  def valid_json?(json)
      JSON.parse(json)
      return true
    rescue JSON::ParserError => e
      return false
  end

  def parse_json_for_sidebar(hash, iteration = 0, request = '', settings = '', table_keys)
    output = ""
    iteration += 1
    hash.each do |key, value|
      padding = "padding-left: #{iteration - 1}em;"
      if value.is_a?(Hash)
        output += "<span class='tooltip-info' style='#{padding}'><strong>#{key.capitalize()}:</strong></span><br />"
        output += parse_json_for_sidebar(value,iteration)
      elsif value.is_a?(Array)
        output += "<span class='tooltip-info' style='#{padding}'><strong>#{key.capitalize()}:</strong></span>"
        value.each do |value|
          if value.is_a?(String) then
            output += "<span class='tooltip-info' style='#{padding}'>#{value}</span>"
          else
            output += parse_json_for_sidebar(value,iteration-1)
          end
        end
      else
        if iteration > 1
          output += "<span class='table-row-info3'><strong>#{key.capitalize()}</strong><br>#{value}</span>"
        else
          if key != '' && value == ''
            value = '<span style="opacity: 0.4">null</span>'
          end
          is_active = ''
          table_keys.each do |value3|
            if value3 == key
              is_active = 'active'
            end
          end
          output += "<div class='table-row-info #{is_active}'>
                      <span class='popup-table-value text-truncate'>#{value}</span>
                      <strong class='popup-table-key'>#{key}</strong>
                    </div>"
        end
      end
    end
    return output
  end
end
