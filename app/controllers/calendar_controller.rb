class CalendarController < ApplicationController
  def index
    @start = DateTime.parse("#{params[:year]}-#{params[:month]}-01")
    @end = @start.end_of_month
    @events = Event.where("start >= ? and start < ?", @start.beginning_of_week(:sunday), @end.end_of_week(:sunday)).includes(:calendar).order("start ASC, stop DESC")

    @month = Month.new(@start, @events)

    @events.each do |event|
      @month.add_event(event)
    end

    @month.weeks.each { |w| w.assemble_lines }
  end
end
