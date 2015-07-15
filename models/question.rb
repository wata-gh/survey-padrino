class Question < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  belongs_to :surveys

  TYPE_NAME = {
    1 => '1つ選択',
    2 => '複数選択',
    9 => 'フリーフォーマット',
  }

  TYPE_COMMENT = {
    1 => '1つ選択してください',
    2 => '複数選択可',
    9 => 'フリーフォーマット',
  }
  def type_name
    TYPE_NAME[self.type]
  end

  def type_comment
    TYPE_COMMENT[self.type]
  end

  def choices
    JSON.parse(self.value, {:symbolize_names => true})
  end

  def sel_sum i
    r = []
    puts '=' * 100
    p self.type
    if self.type == 1
      s = self.answers(i).group(:text).count(:text)
      self.choices.each do |c|
        r << (s[c[:value].to_s].present? ? s[c[:value]] : 0)
      end
      return r
    end
    s = {}
    self.choices.each {|c| s[c[:value].to_s] = 0}
    self.answers(i).each do |a|
      begin
        JSON.parse(a.text).each {|v| s[v] += 1}
      rescue
        s[a.text] += 1
      end
    end
    self.choices.each do |c|
      r << (s[c[:value].to_s].present? ? s[c[:value]] : 0)
    end
    r
  end

  def answers i
    Answer.where(:surveys_id => self.surveys_id, :no => i)
  end
end
