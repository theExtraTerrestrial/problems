#encoding: utf-8
class Setting < ActiveRecord::Base

  validates_presence_of :name
  
  @@cache = Hash.new
  
  def to_s
    self.description.nil? ? self.name : self.description
  end
  
  def Setting.value_for(name,cashing={})
    return Setting.where(:name => name).last.value if cashing == "no_cashing"
    return @@cache[name] unless @@cache[name].nil?
    setting = Setting.where(name: name).first #find(:first, :conditions => ['name = ?', name])
    @@cache[name] = setting.nil? ? nil : setting.value
    @@cache[name]
  end

  def Setting.uncached_value_for(name) 
    setting = Setting.where(name: name).first #.find(:first, :conditions => ['name = ?', name])
    setting.nil? ? nil : setting.value
  end

  def Setting.all_settings
    [
      ["main_admin_email", "Galvenais admina epasts", "example@example.org"],
      
    ]
  end
  
  def Setting.init
    Setting.all_settings.each do |s|
      Setting.create(:name => s[0], :value => s[2], :description => s[1]) unless Setting.where(:name => s[0]).count > 0
    end
  end
end
