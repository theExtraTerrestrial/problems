ActiveAdmin.register AdminUser do
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
  filter :role_id, as: :select, collection: Role.all.map{|u| ["#{u.name}", u.id]}

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :first_name
      f.input :last_name
      f.input :role_id, as: :select, collection: Role.all.map{|u| ["#{u.name}", u.id]}
      f.input :company_id, as: :select, collection: Company.all.map{|u| ["#{u.name}", u.id]}
    end
    f.actions
  end

end
