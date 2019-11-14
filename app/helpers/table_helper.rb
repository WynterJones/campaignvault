module TableHelper
  def buildTable(webhook, settings)
    if webhook.structure.present? && webhook.column_keys.present?
      @structure = webhook.structure.split(',')
      @column_keys = webhook.column_keys.split(',')

      @thead = "<div class='table-simple scrollable'><table class='table datatables'>"
      @thead += "<thead><tr class='text-small'><th></th><th class='hide'></th>"
      @structure.each do |structure|
        @thead += "<th>#{structure.strip}</th>"
      end
      @thead += '</tr></thead>'
      @tbody = '<tbody>'
      @tooltips = ''

      @requests.find_each do |request|
        selected = JSON.parse(request.body)

        if settings.tooltip == true
          @tbody += "<tr data-template='tooltip-#{request.id}'><td class='table-selector'></td><td class='hide'>#{request.id}</td>"
          tooltip = parse_json_for_tooltip(selected, 0, request, settings)
          @tooltips += "<div id='tooltip-#{request.id}' style='display: none'>#{tooltip}</div>"
        else
          @tbody += "<tr><td class='table-selector'></td><td class='hide'></td>"
        end

        @column_keys.each do |column_key|
          value = selected["#{column_key.strip}"]
          if value
            @tbody += "<td>#{value}</td>"
          else
            if column_key == 'timestamp'
              created_at = request.created_at.in_time_zone(settings.timezone).strftime(settings.date_format)
              @tbody += "<td class='table-row-250'>#{created_at}</td>"
            else
              @tbody += "<td><span class='blank-td'></span></td>"
            end
          end
        end
        @tbody += '</tr>'
      end

      @tbody += '</tbody></table></div>'
      @results = @thead + @tbody + @tooltips
    else
      @results = '<p class="text-muted table-no-data">No table columns are setup yet.</p>'
    end
  end
end
