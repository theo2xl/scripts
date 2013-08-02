require 'smarter_csv'

class LiteUserMassUpload

  def self.process(file_name)
    raw_billing_user_data = SmarterCSV.process(file_name, {:downcase_header => false, :strings_as_keys => true})
    billing_user_hash = {}
count = 0;
    raw_billing_user_data.each do |user_hash|
      if user_hash["ProductRatePlanCharge.Id"] == "4028e4852ebd1027012ed9bed14f331e" #2c92a0fb3ef9023e013f01159633192f
        if user_hash["RatePlanCharge.Segment"] == user_hash["RatePlanCharge.Version"]
count+=1
          billing_user_hash[user_hash["Account.AccountNumber"]] = user_hash             
        end
      end
    end
p count    

    File.open("lite_users_mass_upload.csv", "w") do |file|
      file.puts "Subscription Code,Subscription Version,Account Number,Order Type,Order Name (Amendments Only),Change Description (Amendments only),Initial Term,Renewal Term,Term Commitment,AutoRenew,Term Start Date,Save As Draft,Contract Effective Date,Service Activation Date,Customer Acceptance Date,Cancel Subscription Date,Product SKU,Product Name,Rate Plan ID,Rate Plan Name,Rate Plan Component ID,Charge Name,Charge Description,Price,Quantity,# Periods to Prepay,Overage Included Units,Overage Price,Overage (Smoothing) # Periods,Accounting Code,Revenue Recognition Code,Revenue Recognition Trigger Date,Subscription Term Type,Overage Credit Back Option,Overage Credit Back Rate,Price Change Option,Price Increase Percentage,Use Discount Specific Accounting Code,Invoice Account Number,Destination Account Number,Destination Invoice Account Number,Usage Record Rating Option"
      billing_user_hash.each do |key, lite_user_hash|
        file.puts "#{lite_user_hash['Subscription.Name']},,,Remove a Product,Remove Lite Package,,,,,,8/01/2013,,8/01/2013,8/01/2013,8/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,#{lite_user_hash['ProductRatePlan.Id']},Lite Package,,Lite Package Usage,,,,,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        
        #file.puts "Prev,,,,,,,,,,8/01/2013,,8/01/2013,8/01/2013,8/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,,Lite Package,,Lite Package Usage,,0,1,,10000,0.0001,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        
        #file.puts "Prev,,,,,,,,,,8/01/2013,,8/01/2013,8/01/2013,8/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,,Lite Package,,Lite Package Usage,,0,0,,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"                
        
        #Add New Product
        file.puts "Prev,,,New Product,Add New $1 Lite Package,,,,,,8/01/2013,,8/01/2013,8/01/2013,8/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,,Lite Package Usage,,Lite Package,,1,1,0,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        
        #file.puts "Prev,,,,,,,,,,8/01/2013,,8/01/2013,8/01/2013,8/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,,Lite Package Usage,,Lite Package,,1,1,0,,,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
        
        file.puts "Prev,,,,,,,,,,8/01/2013,,8/01/2013,8/01/2013,8/01/2013,,#{lite_user_hash['Product.SKU']},Self-serve Email Plans,,Lite Package Usage,,Lite Package Usage,,,,,10000,0.0001,,,,,#{lite_user_hash['Subscription.TermType']},,,,,,,,,"
      end
    end    
  end

end

LiteUserMassUpload.process(ARGV[0])