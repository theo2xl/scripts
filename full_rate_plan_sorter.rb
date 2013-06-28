require 'smarter_csv'

class FullRatePlanSorter

  def self.process(file_name)
    raw_billing_user_data = SmarterCSV.process(file_name, {:downcase_header => false, :strings_as_keys => true})
    billing_user_hash = {}
    raw_billing_user_data.each do |user_hash|
      if user_hash["RatePlanCharge.Segment"] == user_hash["RatePlanCharge.Version"]
        billing_user_hash[user_hash["Account.AccountNumber"]] = user_hash
      end
    end
    # entry_count = reduced_plans.length
    File.open("active_lite_users.csv", "w") do |file|
      #file.puts "Account Hash"
      billing_user_hash.each do |user_hash|
        # puts entry_count - index - 1
        file.puts "#{user_hash}"
      end
    end 
  end

end

FullRatePlanSorter.process(ARGV[0])