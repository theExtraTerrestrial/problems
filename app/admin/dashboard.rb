ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: 'Galvenais panelis'

  content title: 'Pieteikumu sistēma' do
    columns do
      if can? :manage, AdminUser
        panel 'Jaunākie notikumi' do
          table_for PaperTrail::Version.last(5) do
            column 'Notikums' do |v| I18n.t (v.event) end
            column 'Izraisītājs' do |v| link_to AdminUser.find(v.whodunnit).full_name, admin_admin_user_path(v.whodunnit) rescue "-" end
            column 'Resurss' do |v| link_to v.item_type.constantize.find(v.item_id).name, {controller: "admin/#{v.item_type.underscore.pluralize}", action: :show, id: v.item_id} end
            column 'Izmaiņas' do |v| 
              div do
                ul class: 'ul' do
                  if version_changeset_refiner(v).length > 2
                    truncated_list = version_changeset_refiner(v).take(2)
                    truncated_list.each do |key,val|
                      li "#{I18n.t(key).titleize}: #{val.join(' => ')}" rescue '-'
                    end
                    li link_to "...", {controller: "admin/#{v.item_type.underscore.pluralize}", action: :show, id: v.item_id}
                  else
                    version_changeset_refiner(v).each do |key,val|
                      li "#{I18n.t(key).titleize}: #{val.join(' => ')}" rescue 'a'
                    end
                  end
                end
              end
            end
            column '' do |v| link_to "Apskatīt versiju", admin_version_path(v) end
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
