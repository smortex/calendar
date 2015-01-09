class Calendar < ActiveRecord::Base
  validates_presence_of :name, :color
  validates_uniqueness_of :name

  has_many :events, :dependent => :destroy

  acts_as_nested_set

  COLORS = {
    white:       '#ffffff',
    # Colors from Google Calendar
    green:       '#7bd148',
    bold_blue:   '#5484ed',
    blue:        '#a4bdfc',
    turquoise:   '#46d6db',
    light_green: '#7ae7bf',
    bold_green:  '#51b749',
    yellow:      '#fbd75b',
    orange:      '#ffb878',
    red:         '#ff887c',
    bold_red:    '#dc2127',
    purple:      '#dbadff',
    gray:        '#e1e1e1'
  }
end
