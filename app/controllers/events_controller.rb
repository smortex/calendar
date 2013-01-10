class EventsController < ApplicationController
  def new
    session.delete(:saved_start_date)
    @event = Event.new(params[:event])
  end

  def create
    params[:event][:start] = "#{params[:start_date]} #{params[:start_time]}"
    params[:event][:stop]  = "#{params[:stop_date]} #{params[:stop_time]}"

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

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render :json => @event }
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    params[:event][:start] = "#{params[:start_date]} #{params[:start_time]}"
    params[:event][:stop]  = "#{params[:stop_date]} #{params[:stop_time]}"

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

  # PUT /events/1/procrastinate
  def procrastinate
    @event = Event.find(params.delete(:event_id))
    @event.procrastinate(:days   => params.delete(:days).to_i,
                         :months => params.delete(:months).to_i,
                         :years  => params.delete(:years).to_i)

    @event.save!
    redirect_to(calendar_full_path(:calendar_id => Calendar.find(cookies[:calendar]), :year => @event.start.year, :month => @event.start.month))
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to(calendar_full_path(:calendar_id => cookies[:calendar] || @event.calendar, :year => @event.start.year, :month => @event.start.month))
  end
end
