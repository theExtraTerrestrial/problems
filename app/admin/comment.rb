ActiveAdmin.register ActiveAdmin::Comment do

  menu false
  
  navigation_menu :default
  
  config.breadcrumb = false
  
  permit_params :body
  
  controller do
  
  	def destroy
  		session[:return_to] ||= request.referer
  		destroy!{session.delete(:return_to)}
  	end
  
  	def create
  		session[:return_to] ||= request.referer
  		create!{session.delete(:return_to)}
  	end
  
  	def update
  		session[:return_to] ||= request.referer
  		update!{session.delete(:return_to)}
  	end
  
    def edit
      @page_title = "Rediģēt komentāru"
    end
  end
  
  form do |f|
  	f.inputs do
  		f.input :body, as: :text, label: 'Saturs'
  	end
  	f.actions do
      f.action(:submit) + f.cancel_link(request.referer)
    end
  end

end
