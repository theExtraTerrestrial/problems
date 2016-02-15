ActiveAdmin.register User do

permit_params :name, :image, :description, :surname, :email, :password, :company_id, :role_id

end
