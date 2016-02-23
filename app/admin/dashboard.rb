ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: 'Administrācijas panelis'

  content title: proc {current_admin_user.role.name} do
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
        column do
          panel "Jaunākie pieteikumi" do
            ul do
              Task.recent(5).map do |task|
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

  controller do

    def index
      super
      @tasks = Task.all
    end

  end
end
