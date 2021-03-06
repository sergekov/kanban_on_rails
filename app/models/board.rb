class Board < ActiveRecord::Base
  has_many :users, :through => :user_to_board_connections

  has_many :user_to_board_connections, :dependent => :destroy

  has_many :issues, :dependent => :destroy, :through => :issue_to_section_connections

  has_many :issue_to_section_connections, :dependent => :destroy

  has_many :sections, :dependent => :destroy

  has_many :columns, :dependent => :destroy

  has_many :projects, :through => :project_to_board_connections

  has_many :project_to_board_connections, :dependent => :destroy

  accepts_nested_attributes_for :columns, :allow_destroy => true, :reject_if => :all_blank

  accepts_nested_attributes_for :sections, :allow_destroy => true, :reject_if => :all_blank

  accepts_nested_attributes_for :issue_to_section_connections

  accepts_nested_attributes_for :issues

  validates :name, :length => { :maximum => Settings.max_string_field_size }, :presence => true

  validates :column_width, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0,
    :less_than_or_equal_to => Settings.max_column_width }

  validate :column_tags_overlapping

  after_save :update_issues

  private

  def update_issues
    issues.map(&:save)
  end

  def column_tags_overlapping
    if columns.map(&:tags).map{ |t| t.reject(&:empty?) }.combination(2).map{ |t1, t2| t1 & t2 }.flatten.size > 0
      errors.add(:base, (I18n.t '.shared.form_errors.columns.tag'))
    end
  end
end
