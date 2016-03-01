ActiveAdmin.register AdminUser do
  
  menu :if => proc{ can?(:manage, AdminUser ) }, label: 'Lietotāji'

  permit_params :email, :password, :password_confirmation, :role_id, :company_id, :first_name, :last_name

  index do
    selectable_column
    id_column
    column :email
    column :role_id do |c| Role.find(c.role_id).name end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :created_at
  filter :role_id, as: :select, collection: proc {Role.all.map{|u| ["#{u.name}", u.id]}} if ActiveRecord::Base.connection.table_exists? 'roles'

  form do |f|
    f.inputs "Lietotāja pamatinformācija" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :first_name
      f.input :last_name
      if can? :manage, AdminUser
        f.input :role_id, as: :select, collection: Role.all.map{|u| ["#{u.name}", u.id]}
        f.input :company_id, as: :select, collection: Company.all.map{|u| ["#{u.name}", u.id]}
      end
    end
    f.actions
  end

  show do |s|
    attributes_table do
      row 'Vārds' do |r| r.first_name end
      row 'Uzvārds' do |r| r.last_name end
      row 'Loma' do |r| Role.find(r.role_id).name end
    end
    panel 'Pašreizējie pieteikumi' do
      table_for Task.where('creator_id or responsible_id', current_admin_user.id) do
        column 'Temats', :name
        column 'Aprkasts', :description
        column 'Admina prioritāte', :admin_priority do |t| Task::PRIORITY.key(t.admin_priority) end
        column 'Darbinieka prioritāte', :user_priority do |t| Task::PRIORITY.key(t.user_priority) end
        column 'Kategorija' do |t| Category.find(t.category_id).name end
        column 'Atbildīgais lietotājs' do |t| AdminUser.find(t.responsible_id).full_name rescue "-" end
        column 'Izveidotājs' do |t| AdminUser.find(t.creator_id).full_name end
        if can? :manage, AdminUser 
          column 'Stavoklis' do |t|
            best_in_place t, :state , as: :select, url: [:admin, t], collection: Task::STATUS.keys, value: Task::STATUS.key(t.state), class: 'state_button best_in_place'
          end
        else
          column 'Stavoklis' do |t| Task::STATUS.key(t.state) end
        end
      end
    end
    active_admin_comments
  end

  controller do

      private

        def user_params
          params.require(:user).permit(:email, :password, :password_confirmation, :role_id, :company_id, :first_name, :last_name)
        end 

  end

end
