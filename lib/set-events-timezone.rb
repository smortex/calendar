#!/usr/bin/env ruby
# Rails stores date & time in UTC, so before setting config.time_zone in config/application.rb, all dates should be changed

@total = Event.count
@n = 0

def progress
  @n += 1
  if @n % 2 == 0 then
    if @n % 10 == 0 then
      $stderr.write @n
    else
      $stderr.write '.'
    end
  end
end

if Time.zone.name != 'UTC' then
  $stderr.puts 'The current Time Zone SHALL be UTC.'
  exit 1
end

begin
  fix = TZInfo::Timezone.get(ARGV.last)
rescue
  $stderr.puts 'Last argument MUST be a valid TimeZone name (e.g. "Europe/Paris")'
  exit 1
end

$stderr.write "Fixing TimeZone info for #{@total} events"

Event.transaction do
  Event.all.each do |event|
    event.start = fix.local_to_utc(event.start.utc)
    event.stop  = fix.local_to_utc(event.stop.utc)
    event.save!
    progress
  end
end
$stderr.puts ' done.'
