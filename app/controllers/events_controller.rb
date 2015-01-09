# encoding: UTF-8
class EventsController < ApplicationController
  def new
    session.delete(:saved_start_date)
    @event = Event.new(event_attr)
  end

  def create
    params[:event][:start] = "#{params[:start_date]} #{params[:start_time]}"
    params[:event][:stop]  = "#{params[:stop_date]} #{params[:stop_time]}"

    @event = Event.new(event_attr)
    respond_to do |format|
      if @event.save then
        c = current_calendar
        if !@event.calendar.is_or_is_descendant_of?(c) then
          c = @event.calendar
        end
        format.html { redirect_to(calendar_full_path(:calendar_id => c, :year => @event.start.year, :month => @event.start.month, :anchor => "event-#{@event.id}"), :notice => "Successfully created event «#{@event.title}».") }
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
          @event.recurrence = Recurrence.new(recurrence_attr)
        else
          @event.recurrence.update_attributes(recurrence_attr)
        end
        
        if !@event.recurrence.save then
          flash[:error] = @event.recurrence.errors.full_messages.join("<br />")
          @recurrence = @event.recurrence
          @stop_date = params[:stop_date].to_datetime
          render action: "recurrency"
          return
        end
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

        update_recurrence_last_event(@event.recurrence)
      end
      c = current_calendar
      redirect_to(calendar_full_path(:calendar_id => c, :year => @event.start.year, :month => @event.start.month, :anchor => "event-#{@event.id}"), :notice => "Successfully updated event «#{@event.title}» recurrence.")
    else
      params[:event] ||= {}

      if (params[:start_date] && !params[:start_time] && !params[:stop_date] && !params[:stop_time]) then
        new_start = "#{params[:start_date]} #{@event.start.to_s(:time)}".to_datetime
        params[:event][:start] = new_start.to_s
        params[:event][:stop] = (@event.stop.to_datetime + (new_start - @event.start.to_datetime)).to_s
      end

      params[:event][:start] ||= "#{params[:start_date]} #{params[:start_time]}"
      params[:event][:stop]  ||= "#{params[:stop_date]} #{params[:stop_time]}"

      respond_to do |format|
        begin
          params[:apply] ||= "one"

          start_offset = nil
          stop_offset  = nil

          original_start = @event.start

          @event.assign_attributes(event_attr)
          changes = {}
          @event.changes.each do |k, v|
            case k
            when "start"
              start_offset = v[1] - v[0]
            when "stop"
              stop_offset = v[1] - v[0]
            else
              changes[k] = v[1]
            end
          end

          @events = []

          if params[:operation] == "clone" then
            params[:apply] = "one"
            @event = @event.dup
          end

          case params[:apply]
          when "one" then
            @event.save!
          when "next" then
            @events = @event.recurrence.events.where("start >= ?", original_start)
          when "all" then
            @events = @event.recurrence.events
          else
            raise "FAIL"
          end

          @events.each do |e|
            e.assign_attributes(changes)
            e.start += start_offset unless start_offset.nil?
            e.stop += stop_offset unless stop_offset.nil?
            e.save!
          end

          # Update last recurrence
          if @event.recurrence then
            update_recurrence_last_event(@event.recurrence)
          end

          c = current_calendar
          if !@event.calendar.is_or_is_descendant_of?(c) then
            c = @event.calendar
          end
          format.html { redirect_to(calendar_full_path(:calendar_id => c, :year => @event.start.year, :month => @event.start.month, :anchor => "event-#{@event.id}"), :notice => "Successfully updated event «#{@event.title}».") }
        rescue
          format.html { render action: "edit" }
        end
      end
    end
  end

  # PUT /events/1/procrastinate
  def procrastinate
    @event = Event.find(params.delete(:id))
    @event.procrastinate(:days   => params.delete(:days).to_i,
                         :months => params.delete(:months).to_i,
                         :years  => params.delete(:years).to_i)

    @event.save!
    redirect_to(calendar_full_path(:calendar_id => current_calendar, :year => @event.start.year, :month => @event.start.month, :anchor => "event-#{@event.id}"), :notice => "Successfully procrastinated event «#{@event.title}».")
  end

  # GET /events/1/recurrency
  def recurrency
    @event = Event.find(params.delete(:id))
    @recurrence = @event.recurrence || Recurrence.new
    @last_event_in_serie = @event
    @stop_date = @event.start
    if @event.recurrence then
      @last_event_in_serie = @event.recurrence.last_event
      flash.now[:warning] = %{<strong>This event is not the last occurence of a recurring event.</strong> If you want to add more occurrences, please consider adding recurrency to the <a href="#{recurrency_event_path(@last_event_in_serie)}" class="alert-link"><em>last occurence</em> of this recurring event</a>.} if @last_event_in_serie != @event
      @stop_date = @last_event_in_serie.start.advance(@event.recurrence.to_hash)
    end
  end

  def move
    @event = Event.find(params[:id])
    @event.start = params[:to_date]
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render :json => @event }
    end
  end

  def destroy
    @event = Event.find(params[:id])
    can_undo = false
    if params[:scope] then
      case params[:scope]
        when "next" then
          @event.recurrence.events.where("start >= ?", @event.start).each  { |e| e.destroy }
          update_recurrence_last_event(@event.recurrence)
        when "all" then
          @event.recurrence.destroy
      end
    else
      can_undo = true
      @event.destroy
      update_recurrence_last_event(@event.recurrence)
    end
    notice = "Successfully deleted event «#{@event.title}»."
    if can_undo then
      notice += " (#{undo_link})"
    end
    redirect_to(calendar_full_path(:calendar_id => current_calendar(@event.calendar), :year => @event.start.year, :month => @event.start.month), :notice => notice)
  end

private

  def undo_link
    view_context.link_to("Undo", revert_version_path(@event.versions.scoped.last), :method => :post, class: "alert-link")
  end

  def update_recurrence_last_event(recurrence)
    return if recurrence.nil?

    recurrence.last_event = recurrence.events.order("start DESC").first
    recurrence.save!
  end

  def current_calendar(default = Calendar.order('id').first)
    c = Calendar.find(cookies[:calendar_id] || default)
  end

  def event_attr
    params.require(:event).permit(:body, :calendar_id, :fb, :recurrence_id, :stop, :start, :title)
  end

  def recurrence_attr
    params.require(:recurrence).permit(:days, :months, :weeks, :years)
  end
end
