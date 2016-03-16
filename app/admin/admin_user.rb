ActiveAdmin.register AdminUser do
  
  menu :if => proc{ can?(:manage, AdminUser ) }, label: 'Lietotāji'

  permit_params :email, :password, :password_confirmation, :role_id, :company_id, :first_name, :last_name, :admin_user

  controller do
    def update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end
      super
    end
  end

  index title: 'Lietotāji' do
    selectable_column
    column 'E-pasts', :email
    column 'Loma', :role_id do |c| Role.find(c.role_id).name end
    column 'Uzņēmums', :company_id do |c| Company.find(c.company_id).name rescue "-" end
    column 'Pēdējo reizi ierakstījies', :current_sign_in_at
    column 'Ierakstīšanās reizes', :sign_in_count
    column 'Izveidots', :created_at
    actions
  end

  filter :email, label: 'E-pasts'
  filter :created_at, as: :date_time_range, label: 'Izveidots periodā no-līdz'
  filter :role_id, as: :select, label: 'Loma', collection: proc {Role.all.map{|u| ["#{u.name}", u.id]}} if ActiveRecord::Base.connection.table_exists? 'roles'
  filter :company_id, as: :select, label: 'Uzņēmums', collection: proc {Company.all.map{|u| ["#{u.name}", u.id]}} if ActiveRecord::Base.connection.table_exists? 'companies'

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
    panel 'Lietotāja pamatinformācija' do
      attributes_table_for s do
        row 'Vārds' do |r| r.first_name end
        row 'Uzvārds' do |r| r.last_name end
        row 'Uzņēmums' do |r| r.company.name rescue "-" end
        row 'Loma' do |r| Role.find(r.role_id).name end
      end
    end
    panel 'Pašreizējie pieteikumi' do
      table_for Task.where('creator_id = ? OR responsible_id = ?', current_admin_user.id, current_admin_user.id) do
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
