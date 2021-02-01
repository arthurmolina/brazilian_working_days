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
    @holidays = JSON.parse(File.open("#{__dir__}/data/json/holidays.json").read)
  end

  ##
  # Count working days between two dates
  #
  def working_days_counter(from = Date.today, to)
    return nil if to.blank? || from.blank?

    (to - from).to_i - holidays_counter(from, to, only_weekdays: true) - weekend_days_counter(from, to)
  end

  ##
  # Count holidays between two dates
  #
  def holidays_counter(from = Date.today, to, only_weekdays: false)
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
  def weekend_days_counter(from = Date.today, to)
    return nil if to.blank? || from.blank?

    total_days = (to - from).to_i
    days1 = (2 * (total_days / 7).ceil).to_i
    days2 = ((from + 1 + (total_days - (total_days % 7)).days)..to).map { |date| (1..5).cover?(date.wday) }.count(false)
    days1 + days2
  end

  ##
  # Return a date after X working days
  #
  def working_days_from_today(total_days)
    return nil if total_days.blank?

    working_days_from_date(Date.today, total_days)
  end

  ##
  # Count weekend days between two dates
  #
  def working_days_from_date(from, total_days)
    return nil if total_days.blank? || from.blank?

    days1 = (7*(total_days / 5).ceil).to_i
    checkpoint_date = from + days1.days

    days2 = 0
    days3 = 0
    while days2 < total_days % 5
      days3 += 1
      date = checkpoint_date + days3.days
      days2 += 1 if (1..5).cover?(date.wday) && !holiday?(date)
    end
    checkpoint_date + days3.days
  end

  ##
  # Check if date is holiday
  #
  def holiday?(date)
    return false if date.blank?

    holidays[date.year.to_s].include?(date.strftime('%d/%m/%Y'))
  end
end
