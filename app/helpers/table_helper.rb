module TableHelper
  def buildTable(database, settings, requests, request_count)
    @table_columns = JSON.parse(database.table_columns)

    if request_count == 0
      @results = '<p class="text-muted table-no-data">No data collected yet. Setup Zapier to send test data.</p>'
    elsif @table_columns['structure'].present?
      @structure = @table_columns['structure']
      @column_keys = @table_columns['keys']
      builder(@structure, @column_keys, requests, settings)
    else
      data = JSON.parse(requests.first.data)
      structure = []
      column_keys = []
      counter = 0
      data.each do |value|
        if counter < 4 && value[0].present? && value[1].present?
          counter += 1
          value = value[0].dup
          structure.push(value.gsub('_', ' '))
          column_keys.push("[[#{value}]]")
        end
      end
      builder(structure, column_keys, requests, settings)
    end
  end

  def builder(structure, column_keys, requests, settings)
    @thead = "<div class='table-simple scrollable'><table class='table datatables'>"
    @thead += "<thead><tr class='text-small'><th></th><th class='hide'></th>"
    structure.each do |structure|
      @thead += "<th><span class='text-truncate'>#{structure.strip}</span></th>"
    end
    @thead += '</tr></thead>'
    @tbody = '<tbody>'
    @row_data = ''
    requests.find_each do |request|
      requestBody = JSON.parse(request.data.to_json)
      @tbody += "<tr data-template='tooltip-#{request.id}'><td class='table-selector'></td><td class='hide'>#{request.id}</td>"
      tooltip = parse_json_for_sidebar(requestBody, 0, request, settings, column_keys)
      @row_data += "<div id='tooltip-#{request.id}' style='display: none'>#{tooltip}</div>"
      column_keys.each do |column_key|
        column_data = column_key
        regex = /[[(.*?)]]/
        allkeys =  column_data.scan(/\[\[.*?\]\]/)
        allkeys.each_with_index do |value, index|
          column_data = column_data.gsub(value, "#{requestBody["#{value.gsub('[[', '').gsub(']]', '')}"]}")
        end
        if column_data != ''
          @tbody += "<td><span class='text-truncate'>#{column_data}</span></td>"
        else
          @tbody += "<td><span class='blank-td'></span></td>"
        end
      end
      @tbody += '</tr>'
    end

    @tbody += '</tbody></table></div>'
    @results = @thead + @tbody + @row_data
  end
end
