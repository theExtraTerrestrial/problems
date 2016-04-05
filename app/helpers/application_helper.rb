module ApplicationHelper

  def version_changeset_refiner(obj)
    arr= []
    # raise obj.changeset.inspect
    obj.changeset.to_a.each do |k,v|
      if obj.item_type == "Task"
        if k == "state"
          temp_arr = []
          v.each do |e|
            next if e.nil?
            temp_v = Task::STATUS.key(e)
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "category_id"
          temp_arr = []
          v.each do |e|
            next if e.nil?
            temp_v = Category.find(e).name
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "responsible_id" or k == "admin_user_id" or k == "creator_id"
          temp_arr = []
          v.each do |e|
            next if e.nil?
            temp_v = AdminUser.find(e).full_name
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "admin_priority" or k== "user_priority"
          temp_arr = []
          v.each do |e|
            next if e.nil?
            temp_v = Task::PRIORITY.key(e)
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        elsif k == "company_id"
          temp_arr = []
          v.each do |e|
            next if e.nil?
            temp_v = Company.find(e).name
            temp_arr << temp_v
          end
          arr << [k, temp_arr]
        end      
      end
    end
    return arr
  end	

end


values = [
  # [:creator_id, ""],
  # [:admin_deadline, ""],
  # [:employee_deadline, "" ],
  # [:state, ""],
  # [:category_id, ""],
  # [:responsible_id, "" ],
  # [:admin_user_id, ""],
  # [:user_priority, ""],
  # [:admin_priority, "" ],
  [:closed_by_admin, ""],
  [:closed_by_employee, ""],
  # [:company_id, "" ],
  [:created_at, "" ],
  [:updated_at, "" ],
  # [:id, ""]
]