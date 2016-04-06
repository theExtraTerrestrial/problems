class Emailer < ActionMailer::Base

  ActionMailer::Base.raise_delivery_errors = true
  # ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
      :address  => 'mail.telia.lv',
      :openssl_verify_mode  => 'none',
      :host => 'mail.telia.lv'
      # :address  => 'localhost',
      # :port  => 1025,
    }

  default_url_options[:host] = "#{DOMAIN_NAME}"
  default :from => "Atbalsts SDM <noreply@sdm.lv>"

  def notification(task)
    @object = task
    # raise @object.inspect
    mail(
      :to => unless Setting.where("name=?", @object.category.name+"-email").nil?
        Setting.uncached_value_for('main_admin_email')
      else
        Setting.uncached_value_for("#{@object.category.name}-email")
      end,
      :from => "Atbalsts SDM <noreply@sdm.lv>",
      :subject => "Jauns pieteikums"
    )
  end

  def e_mail(task)
    @object = task
    # raise @object.inspect
    mail(
      :to => "#{AdminUser.find(@object.reciever_id).email}",
      :from => "#{AdminUser.find(@object.sender_id).full_name} <#{AdminUser.find(@object.sender_id).email}>",
      :subject => "Jauns ziņojums"
    )
  end

  def comment_created(comment)
    @object = comment
    mail(
      :to => Setting.uncached_value_for('main_admin_email'),
      :from => "Atbalsts SDM <noreply@sdm.lv>",
      :subject => "Jauns komentārs"
    )
  end



end
