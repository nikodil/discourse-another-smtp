# frozen_string_literal: true

# name: discourse-another-smtp
# about: Another smtp server for emails that banned my main-smtp
# version: 0.0.1
# authors: Lhc_fl
# url: https://github.com/Lhcfl/discourse-another-smtp
# required_version: 3.0.0

enabled_site_setting :discourse_another_email_enabled

after_initialize do

  # Bypass email delivery for specific recipients
  DiscourseEvent.on(:bypass_email_delivery) do |*params|
    if SiteSetting.discourse_another_email_enabled
      message, type = *params

      receiver_in_list = false

      message&.to&.each do |address|
        SiteSetting.discourse_another_email_enabling_mails.split('|').each do |addr|
          receiver_in_list = true if address.include? addr
        end
      end

      # Return true to bypass delivery for these recipients
      if receiver_in_list
        next true # This will prevent the email from being sent
      end
    end

    false # Return false to allow normal delivery
  end


end

# message.delivery_method.settings is like:
# {:address=>"localhost",
#  :port=>1025,
#  :domain=>"localhost.localdomain",
#  :user_name=>nil,
#  :password=>nil,
#  :authentication=>nil,
#  :enable_starttls=>nil,
#  :enable_starttls_auto=>true,
#  :openssl_verify_mode=>nil,
#  :ssl=>nil,
#  :tls=>nil,
#  :open_timeout=>5,
#  :read_timeout=>5,
#  :return_response=>true}
