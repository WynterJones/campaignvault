class ExportController < ApplicationController
  before_action :authenticate_user!
  require "csv"

  def export
    settings = Setting.find_by_user_id(current_user.id)

    if params[:tags].present?
      tag = Tag.find_by(id: params[:id])
      requests = Request.where(tag_id: params[:id])
      data = tag
    else
      app = App.find_by(id: params[:id])
      requests = Request.where(webhook_id: app.id)
      data = app
    end

    headers = data.structure.split(',')
    column_keys = data.column_keys.split(',')
    rowArray = []

    csvData = CSV.generate(headers: true) do |csv|
      csv << headers

      requests.each do |request|
        selected = JSON.parse(request.body)

        column_keys.each do |column_key|
          value = selected["#{column_key.strip}"]
          if value.present?
            rowArray << value
          else
            if column_key == 'timestamp'
              rowArray << request.created_at.in_time_zone(settings.timezone).strftime(settings.date_format)
            elsif column_key == 'tag' && request.tag_id.present?
              rowArray << Tag.find(request.tag_id).name
            else
              rowArray << ''
            end
          end
        end

        csv << rowArray
        rowArray = []
      end
    end

    send_data csvData, filename: "#{data.name}-#{requests.count}.csv", disposition: :attachment
  end
end
