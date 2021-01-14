# frozen_string_literal: true

require 'json'
require 'date'
require 'active_support'
require 'active_support/time'

##
# Brazilian Working Days main functions
#
class BrazilianWorkingDays
  attr_accessor :holidays

  def initialize
    @holidays = get_holidays
  end

  ##
  # Count business days between two dates
  #
  def business_days_counter(to, from = Date.today)
    return nil if to.blank? || from.blank?

    (to - from).to_i - holidays_counter(to, from, only_weekdays: true) - weekend_days_counter(to, from)
  end

  ##
  # Count holidays between two dates
  #
  def holidays_counter(to, from = Date.today, only_weekdays: false)
    return nil if to.blank? || from.blank?

    counter = 0
    years = (from.year..to.year).to_a.map(&:to_s)
    years.each do |year|
      break if year.to_i > to.year

      holidays[year].sort{ |date1, date2| Date.parse(date1) <=> Date.parse(date2) }.each do |date|
        break if Date.parse(date) > to

        parsed_date = Date.parse(date)
        counter += 1 if parsed_date >= from && (!only_weekdays || (1..5).cover?(parsed_date.wday))
      end
    end
    counter
  end

  ##
  # Count weekend days between two dates
  #
  def weekend_days_counter(to, from = Date.today)
    return nil if to.blank? || from.blank?

    totals_days = (to - from).to_i
    days1 = (2 * (totals_days / 7).ceil).to_i
    days2 = ((from + (totals_days - (totals_days % 7)).days)..to).map { |date| (1..5).cover?(date.wday) }.count(false)
    days1 + days2
  end

  private

  ##
  # Get all brazilian holidays beetween 2001 and actual year
  def get_holidays
    begin
      parsed_json = JSON.parse(File.open("#{__dir__}/data/json/holidays.json").read)
      if parsed_json.blank? || !parsed_json.keys.include?(Time.now.year.to_s)
        system("ruby #{__dir__}/data/create_json.rb")
        parsed_json = JSON.parse(File.open("#{__dir__}/data/json/holidays.json").read)
      end
      parsed_json
    rescue StandardError
      system("ruby #{__dir__}/data/create_json.rb")
      JSON.parse(File.open("#{__dir__}/data/json/holidays.json").read)
    end
  end
end
