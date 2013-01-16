class Recurrence < ActiveRecord::Base
  attr_accessible :days, :months, :weeks, :years

  validates :days, :months, :weeks, :years, :numericality => true

  has_many :events, :dependent => :destroy

  def to_hash
    { days: days, months: months, weeks: weeks, years: years }
  end
end
