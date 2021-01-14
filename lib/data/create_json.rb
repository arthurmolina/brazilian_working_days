# frozen_string_literal: true

## This file generate jsons with all of brazillian holidays based on anbima website

require 'httparty'
require 'nokogiri'

holidays = {}
(2001..(Time.now.year)).each do |year|
  html_document = Nokogiri::HTML(HTTParty.get("https://www.anbima.com.br/feriados/fer_nacionais/#{year}.asp").body)

  holidays[year.to_s] = []
  html_document.css('.tabela').each do |td|
    begin
      parsed_date = Time.parse td.text.split('/').reverse.join('/')
      holidays[year.to_s] << parsed_date.strftime('%d/%m/%Y').to_s
    rescue StandardError
      next
    end
  end
end

File.open("#{__dir__}/json/holidays.json", 'w') do |f|
  f.write(holidays.to_json)
end
