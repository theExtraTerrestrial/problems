ActiveAdmin.register ActiveAdmin::Comment do

  menu if: proc{can? :manage, AdminUser}, label: 'Komentāri'
  index title: 'Komentāri'

end