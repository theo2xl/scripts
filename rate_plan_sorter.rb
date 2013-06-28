require 'smarter_csv'

class RatePlanSorter

  def self.process(file_name)
    raw_billing_user_data = SmarterCSV.process(file_name, {:downcase_header => false, :strings_as_keys => true})
    billing_user_hash = {}
    raw_billing_user_data.each do |user_hash|
      unless billing_user_hash[user_hash["Account.AccountNumber"]]
        if user_hash["RatePlanCharge.Segment"] == user_hash["RatePlanCharge.Version"]
          billing_user_hash[user_hash["Account.AccountNumber"]] = user_hash["ProductRatePlan.Id"]
        end
      end
    end
    # entry_count = reduced_plans.length
    File.open("active_lite_users.csv", "w") do |file|
      file.puts "customer id, rate plan id"
      billing_user_hash.each do |key, value|
        # puts entry_count - index - 1
        file.puts "#{key}, #{value}"
      end
    end 
  end

end

RatePlanSorter.process(ARGV[0])