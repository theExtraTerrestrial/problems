class Emailer < ActionMailer::Base

  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
      :address  => 'mail.telia.lv',
      #:port  => 25,
      :openssl_verify_mode  => 'none',
      :host => 'mail.telia.lv'
    }

  default_url_options[:host] = "#{DOMAIN_NAME}"
  default :from => "Atbalsts SDM <noreply@sdm.lv>"

  def notification(task)
    @object = task
    # raise @object.inspect
    mail(
      :to => Setting.uncached_value_for('main_admin_email'),
      :from => "Atbalsts SDM <noreply@sdm.lv>",
      :subject => "Jauns pieteikums"
    )
  end  

end