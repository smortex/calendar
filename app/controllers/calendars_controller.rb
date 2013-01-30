# encoding: UTF-8
class CalendarsController < ApplicationController
  def index
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = Calendar.new(params[:calendar])
    respond_to do |format|
      if @calendar.save then
        format.html { redirect_to(calendars_path, :notice => "Successfully created calendar «#{@calendar.name}».") }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    begin
      @calendar = Calendar.find(params[:calendar_id] || params[:id] || cookies[:calendar])
    rescue
      @calendar = Calendar.find(:first)
      if @calendar.nil? then
        redirect_to(calendars_path)
        return
      end
    end

    cookies[:calendar] = @calendar.id

    params[:year] ||= DateTime.now.end_of_week(:sunday).year
    params[:month] ||= DateTime.now.end_of_week(:sunday).month

    if params[:save_start_date] then
      session[:saved_start_date] = params[:save_start_date]
    end

    @start = DateTime.parse("#{params[:year]}-#{params[:month]}-01")
    @end = @start.end_of_month
    @events = Event.where(:calendar_id => @calendar.self_and_descendants).where("start < ? AND stop > ?", @end.end_of_week(:sunday), @start.beginning_of_week(:sunday)).includes(:calendar, :recurrence).order("start ASC, stop DESC")

    @month = Month.new(@start, @events)

    @events.each do |event|
      @month.add_event(event)
    end

    @month.weeks.each { |w| w.assemble_lines }
  end

  def edit
    @calendar = Calendar.find(params[:id])
  end

  def update
    @calendar = Calendar.find(params[:id])
    respond_to do |format|
      if @calendar.update_attributes(params[:calendar]) then
        format.html { redirect_to(calendars_path, :notice => "Successfully updated calendar «#{@calendar.name}».") }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @calendar = Calendar.find(params[:id])
    @calendar.destroy
    redirect_to(calendars_path, :notice => "Successfully destroyed calendar «#{@calendar.name}».")
  end
end
