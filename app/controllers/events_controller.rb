class EventsController < ApplicationController
  def new
    @event = Event.new
  end
  def create
    @event = Event.new(params[:event])
    respond_to do |format|
      if @event.save then
        format.html { redirect_to "/#{@event.start.year}/#{@event.start.month}" }
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
        format.html { redirect_to "/#{@event.start.year}/#{@event.start.month}" }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to "/#{@event.start.year}/#{@event.start.month}"
  end
end
