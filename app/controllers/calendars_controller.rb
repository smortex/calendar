class CalendarsController < ApplicationController
  def index
    params[:year] ||= DateTime.now.year
    params[:month] ||= DateTime.now.month

    @start = DateTime.parse("#{params[:year]}-#{params[:month]}-01")
    @end = @start.end_of_month
    @events = Event.where("start >= ? and start < ?", @start.beginning_of_week(:sunday), @end.end_of_week(:sunday)).includes(:calendar).order("start ASC, stop DESC")

    @month = Month.new(@start, @events)

    @events.each do |event|
      @month.add_event(event)
    end

    @month.weeks.each { |w| w.assemble_lines }
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(params[:calendar])
    respond_to do |format|
      if @calendar.save then
        format.html { redirect_to(calendars_path) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
  end

  def edit
    @calendar = Calendar.find(params[:id])
  end

  def update
    @calendar = Calendar.find(params[:id])
    respond_to do |format|
      if @calendar.update_attributes(params[:calendar]) then
        format.html { redirect_to(calendars_path) }
      else
        format.html { render action: "edit" }
      end
    end
  end
end
