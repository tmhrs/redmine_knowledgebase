class KbProjectSettings < ActiveRecord::Base
  unloadable
  belongs_to :project

  def self.find_or_create(project_id)
    setting = KbProjectSettings.find(:first, :conditions => ['project_id = ?', project_id])
    unless setting
      setting = KbProjectSettings.new
      setting.project_id = project_id
      setting.save!
    end
    return setting
  end
end
