module ApplicationHelper

  def version_changeset_refiner(obj)
    arr= []
    # raise obj.changeset.inspect
    obj.changeset.to_a.each do |k,v|
      if obj.item_type == "Task"
        if k == "state"
          temp_arr = []
          v.each do |e|
            if e.nil? or e == 0
              temp_v = "-"
            else
              temp_v = Task::STATUS.key(e)
            end
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "category_id"
          temp_arr = []
          v.each do |e|
            if e.nil? or e == 0
              temp_v = "-"
            else
              temp_v = Category.find(e).name
            end
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "responsible_id" or k == "admin_user_id" or k == "creator_id"
          temp_arr = []
          v.each do |e|
            if e.nil? or e == 0
              temp_v = "-"
            else
              temp_v = AdminUser.find(e).full_name
            end
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "admin_priority" or k== "user_priority"
          temp_arr = []
          v.each do |e|
            if e.nil? or e == 0
              temp_v = "-"
            else
              temp_v = Task::PRIORITY.key(e)
            end
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "company_id"
          temp_arr = []
          v.each do |e|
            if e.nil? or e == 0
              temp_v = "-"
            else
              temp_v = Company.find(e).name
            end
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "closed_by_admin" or k == "closed_by_employee"
          temp_arr = []
          v.each do |e|
            temp_v = e.nil? ? " " : I18n.t(e)
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        end      
      end
    end
    return arr
  end	

end
