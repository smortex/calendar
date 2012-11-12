class Calendar < ActiveRecord::Base
  attr_accessible :color, :name

  validates_presence_of :name, :color
  validates_uniqueness_of :name

  has_many :events

  def self.import_from_plans(dir)
    id_assoc = {}
    decoder = ApplicationHelper::PlansDecoder.new

    Calendar.transaction do
    Event.transaction do
    puts "Importing calendars..."
    File.open(dir + "/calendars.xml") do |file|
      while (line = file.gets) do
        hc = Hash.from_xml(line)
        c = Calendar.create(:name => decoder.decode(hc['calendar']['title']), :color => decoder.decode(hc['calendar']['calendar_events_color']))
        id_assoc[hc['calendar']['id'].to_i] = c.id
      end
    end

    puts "Importing events..."
    File.open(dir + "/events.xml") do |file|
      while (line = file.gets) do
        he = Hash.from_xml(line)
        e = Event.create(:calendar_id => id_assoc[he['event']['cal_ids'].to_i], :title => decoder.decode(he['event']['title']), :body => decoder.decode(he['event']['details']), :start => DateTime.strptime(he['event']['start'], "%s"), :stop => DateTime.strptime(he['event']['end'], "%s"))
      end
    end
end
end
  end
end
