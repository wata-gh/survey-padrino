class Surveys < ActiveRecord::Base
  has_many :questions, :dependent => :destroy, :autosave => true
  has_many :answers, :dependent => :destroy
  validates_presence_of :name
  validates_presence_of :questions, :on => :update
  paginates_per 10
  before_save :create_hash_key

  def create_hash_key
    if self.hash_key.blank?
      self.hash_key = Digest::MD5.hexdigest(self.name + Time.now.to_s)
    end
  end
end
