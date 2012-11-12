class PlansImporter
  def initialize(dir = "/usr/local/www/plans/data")
    @dir = dir
    @decoder = ApplicationHelper::PlansDecoder.new
  end

  def import
    misc = {}

    Calendar.transaction do
      Event.transaction do
        puts "Importing calendars..."
        File.open(@dir + "/calendars.xml") do |file|
          while (line = file.gets) do
            hc = Hash.from_xml(line)
            color = @decoder.decode(hc['calendar']['calendar_events_color'])
            color = "#ffffff" if (color == "")
            c = Calendar.create!(:name => @decoder.decode(hc['calendar']['title']) + " (imported)", :color => color)
            puts "#{c.name} = #{c.id}"
            misc[hc['calendar']['id'].to_i] = { :id => c.id, :tz => hc['calendar']['gmtime_diff'].to_i }
          end
        end

        puts "Importing events..."
        File.open(@dir + "/events.xml") do |file|
          while (line = file.gets) do
            he = Hash.from_xml(line)
            e = Event.new(:calendar_id => misc[he['event']['cal_ids'].to_i][:id], :title => @decoder.decode(he['event']['title']), :body => @decoder.decode(he['event']['details']), :start => DateTime.strptime(he['event']['start'], "%s"), :stop => DateTime.strptime(he['event']['end'], "%s"))
            if (e.start.strftime("%H:%M") != "00:00" || e.stop.strftime("%H:%M") != "23:59") then
              e.start += misc[he['event']['cal_ids'].to_i][:tz].hours
              e.stop  += misc[he['event']['cal_ids'].to_i][:tz].hours
            end
            e.save!
          end
        end
      end
    end
  end
end
