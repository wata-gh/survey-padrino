class Surveys < ActiveRecord::Base
  has_many :questions, :dependent => :destroy, :autosave => true
  has_many :answers, :dependent => :destroy
  validates_presence_of :name
  validates_presence_of :questions, :on => :update
  paginates_per 10
end
