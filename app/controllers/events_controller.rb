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
    @event = Event.find(params[:id])

    if params[:recurrence] then
      Event.transaction do
        if @event.recurrence.nil? then
          @event.recurrence = Recurrence.new(params[:recurrence])
        else
          @event.recurrence.update_attributes(params[:recurrence])
        end
        
        @event.recurrence.save!
        @event.save!

        stop = params[:stop_date].to_datetime.end_of_day
        next_start = @event.start.advance(@event.recurrence.to_hash)
        while next_start < stop do
          other = @event.dup
          other.start = next_start
          other.stop = @event.stop.advance(@event.recurrence.to_hash)
          other.save!
          @event = other
          next_start = @event.start.advance(@event.recurrence.to_hash)
        end
      end
      c = Calendar.find(cookies[:calendar])
      redirect_to(calendar_full_path(:calendar_id => c, :year => @event.start.year, :month => @event.start.month))
    else
    params[:event][:start] = "#{params[:start_date]} #{params[:start_time]}"
    params[:event][:stop]  = "#{params[:stop_date]} #{params[:stop_time]}"

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

  # GET /events/1/recurrency
  def recurrency
    @event = Event.find(params.delete(:event_id))
    @recurrence = @event.recurrence || Recurrence.new
    @last_event_in_serie = @event
    @stop_date = @event.start
    if @event.recurrence then
      @last_event_in_serie = @event.recurrence.events.order("start DESC").limit(1)[0]
      @stop_date = @last_event_in_serie.start
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if params[:scope] then
      case params[:scope]
        when "next" then
          @event.recurrence.events.where("start >= ?", @event.start).each  { |e| e.destroy }
        when "all" then
          @event.recurrence.destroy
      end
    else
    @event.destroy
    end
    redirect_to(calendar_full_path(:calendar_id => cookies[:calendar] || @event.calendar, :year => @event.start.year, :month => @event.start.month))
  end
end
