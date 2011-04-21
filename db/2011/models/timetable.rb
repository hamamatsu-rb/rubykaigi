
require File.join(File.dirname(__FILE__), "room_timetable")

class Timetable
  def room_timetables
    @room_timetable ||= RoomTimetable.all
  end

  def days
    room_timetables.map {|r| r.date }.uniq
  end

  def room_timetables_on(date)
    room_timetables.select {|r| r.date == date }
  end

end
