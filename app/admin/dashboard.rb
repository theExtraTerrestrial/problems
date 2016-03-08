ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: 'Galvenais panelis'

  content title: proc {current_admin_user.role.name} do
    columns do
      if current_admin_user.role.name.downcase == 'admin'
        column do
          panel "Tev uzticētie pieteikumi" do
            table_for Task.where('responsible_id', current_admin_user.id).map do
              column '' do |t| link_to(t.name, admin_task_path(t)) end
              column '' do |t| t.created_at.to_datetime.strftime('%d.%m.%Y %H:%M') end
              column '' do |t| status_tag Task::STATUS.key(t.state), class: "#{Task::STATUS.key(t.state)}" end
            end
          end
        end
        column do
          panel "Jaunākie pieteikumi" do
            table_for Task.recent(10).map do
              column '' do |t| link_to(t.name, admin_task_path(t)) end
              column '' do |t| t.created_at.to_datetime.strftime('%d.%m.%Y %H:%M') end
              column '' do |t| status_tag Task::STATUS.key(t.state), class: "#{Task::STATUS.key(t.state)}" end
            end
          end
        end
        column do
          panel "Nepabeigtie pieteikumi" do
            table_for Task.where(state: 1..2).map do
              column '' do |t| link_to(t.name, admin_task_path(t)) end
              column '' do |t| t.created_at.to_datetime.strftime('%d.%m.%Y %H:%M') end
              column '' do |t| status_tag Task::STATUS.key(t.state), class: "#{Task::STATUS.key(t.state)}" end
            end
          end
        end
      elsif current_admin_user.role.name.downcase == 'darbinieks'
        column do
          panel "Tavi pieteikumi" do
            ul do
              Task.where('creator_id', current_admin_user.id).each do |task|
                li link_to(task.name+" (#{Task::STATUS.key(task.state)})", admin_task_path(task))
              end
            end
            a link_to('Izveidot pieteikumu', new_admin_task_path)
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
