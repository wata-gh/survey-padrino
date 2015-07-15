class Surveys < ActiveRecord::Base
  has_many :questions, :dependent => :destroy
  has_many :answers, :dependent => :destroy
  validates_presence_of :name
  paginates_per 10
end
