ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      if current_admin_user.role.name.downcase == 'admin'
        column do
          panel "Tev uzticētie pieteikumi" do
            ul do
              Task.where('responsible_id', current_admin_user.id).map do |task|
                li link_to(task.name, admin_task_path(task))
              end
            end
          end
        end
      elsif current_admin_user.role.name.downcase == 'darbinieks'
        column do
          panel "Tavi pieteikumi" do
            ul do
              Task.where('creator_id', current_admin_user.id).map do |task|
                li link_to(task.name, admin_task_path(task))
              end
            end
          end
        end
      else
        panel "Welcome" do
          ul do
            li 'Welcome'
          end
        end
      end
    end
  end
end
