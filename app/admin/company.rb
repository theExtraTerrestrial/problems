ActiveAdmin.register Company do

menu :parent => "Administrācija", label: 'Uzņēmumi'
index title: 'Uzņēmumi'

permit_params :name

end
