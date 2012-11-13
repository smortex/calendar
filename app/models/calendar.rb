class Calendar < ActiveRecord::Base
  attr_accessible :color, :name, :parent_id

  validates_presence_of :name, :color
  validates_uniqueness_of :name

  has_many :events, :dependent => :destroy

  acts_as_nested_set
end
