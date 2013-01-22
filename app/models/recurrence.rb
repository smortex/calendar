class Recurrence < ActiveRecord::Base
  attr_accessible :days, :months, :weeks, :years

  validates :days, :months, :weeks, :years, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validate :non_null_recurrence

  has_many :events, :dependent => :destroy

  belongs_to :last_event, :class_name => "Event"

  def to_hash
    { days: days, months: months, weeks: weeks, years: years }
  end

  def non_null_recurrence
    if days == 0 && months == 0 && weeks == 0 && years == 0 then
      errors.add(:days, "indicate a null duration")
    end
  end
end
