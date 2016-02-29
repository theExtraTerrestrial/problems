class Emailer < ActionMailer::Base

  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
      :address  => 'mail.telia.lv',
      #:port  => 25,
      :openssl_verify_mode  => 'none',
      :host => 'mail.telia.lv'
    }

  default_url_options[:host] = "#{DOMAIN_NAME}"
  default :from => "99 Problems <noreply@99problems.lv>"

  # def notification(calendar_event)
  #   @object = calendar_event
  #   mail(
  #     :to => Setting.uncached_value_for('admin_mail'),
  #     :from => "Trejdevini Saieti <noreplay@saietstrejdevini.lv>",
  #     :subject => "Jauns pieteikums"
  #   )
  # end  

end