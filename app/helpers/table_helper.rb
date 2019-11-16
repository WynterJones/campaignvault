module TableHelper
  def buildTable(app, settings)
    @table_columns = JSON.parse(app.table_columns)
    if @table_columns['structure'].present?
      @structure = @table_columns['structure']
      @column_keys = @table_columns['keys']

      @thead = "<div class='table-simple scrollable'><table class='table datatables'>"
      @thead += "<thead><tr class='text-small'><th></th><th class='hide'></th>"
      @structure.each do |structure|
        @thead += "<th>#{structure.strip}</th>"
      end
      @thead += '</tr></thead>'
      @tbody = '<tbody>'
      @row_data = ''

      @requests.find_each do |request|
        requestBody = JSON.parse(request.body)
        @tbody += "<tr data-template='tooltip-#{request.id}'><td class='table-selector'></td><td class='hide'></td>"
        tooltip = parse_json_for_sidebar(requestBody, 0, request, settings, @column_keys)
        @row_data += "<div id='tooltip-#{request.id}' style='display: none'>#{tooltip}</div>"

        @column_keys.each do |column_key|
          column_data = column_key
          regex = /[[(.*?)]]/
          allkeys =  column_data.scan(/\[\[.*?\]\]/)
          allkeys.each_with_index do |value, index|
            column_data = column_data.gsub(value, "#{requestBody["#{value.gsub('[[', '').gsub(']]', '')}"]}")
          end
          if column_data != ''
            @tbody += "<td>#{column_data}</td>"
          else
            @tbody += "<td><span class='blank-td'></span></td>"
          end
        end
        @tbody += '</tr>'
      end

      @tbody += '</tbody></table></div>'
      @results = @thead + @tbody + @row_data
    else
      @results = '<p class="text-muted table-no-data">No table columns are setup yet.</p>'
    end
  end
end
