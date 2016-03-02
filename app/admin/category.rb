ActiveAdmin.register Category do

  menu :parent => "Administrācija", label: 'Kategorijas'
  index title: 'Kategorijas'
  
  permit_params :name
  
end
