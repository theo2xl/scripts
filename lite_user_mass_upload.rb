require 'smarter_csv'

class LiteUserMassUpload

  def self.process(file_name)
    raw_billing_user_data = SmarterCSV.process(file_name, {:downcase_header => false, :strings_as_keys => true})
    billing_user_hash = {}
    raw_billing_user_data.each do |user_hash|
      if user_hash["RatePlanCharge.Segment"] == user_hash["RatePlanCharge.Version"]
        billing_user_hash[user_hash["Account.AccountNumber"]] = user_hash
      end
    end 

    File.open("lite_users_mass_upload.csv", "w") do |file|
      file.puts "Subscription Code,Subscription Version,Account Number,Order Type,Order Name (Amendments Only),Change Description (Amendments only),Initial Term,Renewal Term,Term Commitment,AutoRenew,Term Start Date,Save As Draft,Contract Effective Date,Service Activation Date,Customer Acceptance Date,Cancel Subscription Date,Product SKU,Product Name,Rate Plan ID,Rate Plan Name,Rate Plan Component ID,Charge Name,Charge Description,Price,Quantity,# Periods to Prepay,Overage Included Units,Overage Price,Overage (Smoothing) # Periods,Accounting Code,Revenue Recognition Code,Revenue Recognition Trigger Date,Subscription Term Type,Overage Credit Back Option,Overage Credit Back Rate,Price Change Option,Price Increase Percentage,Use Discount Specific Accounting Code,Invoice Account Number,Destination Account Number,Destination Invoice Account Number,Usage Record Rating Option"
      billing_user_hash.each do |key, lite_user_hash|
        # Remove old Lite Package for $0
        file.puts "#{lite_user_hash['Subscription.Name']},,,Remove a Product,Remove $0 Lite Package,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,#{lite_user_hash['ProductRatePlan.Id']},Lite Package,,Lite Package Usage,,,,,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        file.puts "Prev,,,,,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,#{lite_user_hash['ProductRatePlan.Id']},Lite Package,,Lite Package Usage,,0,1,,10000,0.0001,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        file.puts "Prev,,,,,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,#{lite_user_hash['ProductRatePlan.Id']},Lite Package,,Lite Package Usage v2,,0,0,,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        # file.puts "Prev,,,,,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,#{lite_user_hash['ProductRatePlan.Id']},Lite Package,,Lite Package Usage,,0,0,,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        # Add 'New Product' of 'New Lite Plan' with 'Lite Package Monthly Minimum' and 'Lite Package Usage'
        file.puts "Prev,,,New Product,Lite Package Price Change,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,,New Lite Plan,,Lite Package Monthly Minimum,,,,,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        file.puts "Prev,,,,,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,,New Lite Plan,,Lite Package Monthly Minimum,,,1,1,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        file.puts "Prev,,,,,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,,New Lite Plan,,Lite Package 10k Usage,,,,,10000,0.0001,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
      end
    end    
  end

end

LiteUserMassUpload.process(ARGV[0])