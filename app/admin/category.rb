ActiveAdmin.register Category do

  menu :parent => "Administrācija", label: 'Kategorijas'
  
  permit_params :name, :admin_user_id

  index title: 'Kategorijas' do
  	column 'Nosaukums', :name, sortable: :name
  	column 'Atbildīgais admins' do |t|
  		best_in_place t, :admin_user_id , as: :select, url: [:admin, t], collection: AdminUser.admins, class: "best_in_place"
    end
    column 'Admina epasts' do |t| t.admin_user.email rescue "Nav noteikts" end
  end
  
end
