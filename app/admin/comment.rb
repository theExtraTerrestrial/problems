ActiveAdmin.register ActiveAdmin::Comment do

menu label: 'Komentāri', parent: 'Administrācija'

controller do

	def destroy
		session[:return_to] ||= request.referer
		destroy!{session.delete(:return_to)}
	end

	def create
		session[:return_to] ||= request.referer
		create!{session.delete(:return_to)}
	end
end

form do |f|
	f.inputs do
		f.input :body, as: :text, label: 'Saturs'
	end
	f.actions
end

end
