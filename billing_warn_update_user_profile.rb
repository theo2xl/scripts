require 'smarter_csv'

class BillingWarnUpdateUserProfile

  def self.process(file_name)
    raw_data = SmarterCSV.process(file_name, {:downcase_header => false, :strings_as_keys => true})
    
    billing_warn_array = Array.new(raw_data.length)

    raw_data.each do |declined_user|
      billing_warn_array << declined_user['Subscription.UserId__c']
    end

p billing_warn_array.join(',')

  end

end

BillingWarnUpdateUserProfile.process(ARGV[0])