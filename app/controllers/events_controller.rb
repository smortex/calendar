class EventsController < ApplicationController
  def new
    @event = Event.new(params[:event])
  end

  def create
    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.save then
        c = Calendar.find(cookies[:calendar] || Calendar.first)
        if !@event.calendar.is_or_is_descendant_of?(c) then
          c = @event.calendar
        end
        format.html { redirect_to(calendar_full_path(:calendar_id => c, :year => @event.start.year, :month => @event.start.month)) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update_attributes(params[:event]) then
        c = Calendar.find(cookies[:calendar])
        if !@event.calendar.is_or_is_descendant_of?(c) then
          c = @event.calendar
        end
        format.html { redirect_to(calendar_full_path(:calendar_id => c, :year => @event.start.year, :month => @event.start.month)) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to(calendar_full_path(:calendar_id => cookies[:calendar] || @event.calendar, :year => @event.start.year, :month => @event.start.month))
  end
end
