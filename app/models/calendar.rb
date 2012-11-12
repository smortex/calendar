class Calendar < ActiveRecord::Base
  attr_accessible :color, :name

  validates_presence_of :name, :color
  validates_uniqueness_of :name

  has_many :events, :dependent => :destroy
end
