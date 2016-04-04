ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: 'Galvenais panelis'

  content title: 'Pieteikumu sistēma' do
    columns do
      if can? :manage, AdminUser
        panel 'Jaunākie notikumi' do
          table_for PaperTrail::Version.last(5) do
            column 'Atbildīgais' do |v| link_to AdminUser.find(v.whodunnit).full_name, admin_admin_user_path(v.whodunnit) rescue "-" end
            column 'Resursa tips' do |v| I18n.t(v.item_type.downcase) end
            column 'Notikums' do |v| I18n.t (v.event) end
            column 'Izmaiņas' do |v| 
              div do
                ul class: 'ul' do
                  if v.changeset.to_a.length > 2
                    truncated_list = v.changeset.to_a.take(2)
                    truncated_list.each do |key,val| 
                      li "#{I18n.t(key).titleize}: #{val.join(' => ')}"
                    end
                    li link_to "...", admin_root_path
                  else
                    v.changeset.to_a.each do |key,val|
                      li "#{I18n.t(key).titleize}: #{val.join(' => ')}"
                    end
                  end
                end
              end
            end
          end
        end
        column do
          panel "Tev uzticētie pieteikumi" do
            table_for Task.where('responsible_id = ?', current_admin_user.id).map do
              column 'Temats'    do |t| link_to(t.name, admin_task_path(t)) end
              column 'Uzņēmums'  do |t| t.admin_user.company.name rescue "-" end
              column 'Izveidots' do |t| t.created_at.to_datetime.strftime('%d.%m.%Y %H:%M') end
              column 'Stāvoklis' do |t| status_tag Task::STATUS.key(t.state), class: "#{Task::STATUS.key(t.state)}" end
            end
          end
        end
        column do
          panel "Jaunākie pieteikumi" do
            table_for Task.recent(10).map do
              column 'Temats'    do |t| link_to(t.name, admin_task_path(t)) end
              column 'Uzņēmums'  do |t| t.admin_user.company.name rescue "-" end
              column 'Izveidots' do |t| t.created_at.to_datetime.strftime('%d.%m.%Y %H:%M') end
              column 'Stāvoklis' do |t| status_tag Task::STATUS.key(t.state), class: "#{Task::STATUS.key(t.state)}" end
            end
          end
        end
        column do
          panel "Nepabeigtie pieteikumi" do
            table_for Task.where(state: 1..2).map do
              column 'Temats'    do |t| link_to(t.name, admin_task_path(t)) end
              column 'Uzņēmums'  do |t| t.admin_user.company.name rescue "-" end
              column 'Izveidots' do |t| t.created_at.to_datetime.strftime('%d.%m.%Y %H:%M') end
              column 'Stāvoklis' do |t| status_tag Task::STATUS.key(t.state), class: "#{Task::STATUS.key(t.state)}" end
            end
          end
        end
      elsif current_admin_user.role.name.downcase == 'darbinieks'
        column do
          panel "Tavi pieteikumi" do
            table_for Task.where('creator_id = ?', current_admin_user.id).each do |task|
              column 'Temats'  do |t| link_to(t.name, admin_task_path(t)) end
              column 'Izveidots' do |t| t.created_at.to_datetime.strftime('%d.%m.%Y %H:%M') end
              column 'Stāvoklis' do |t| status_tag Task::STATUS.key(t.state), class: "#{Task::STATUS.key(t.state)}" end
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
