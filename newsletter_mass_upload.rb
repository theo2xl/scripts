require 'smarter_csv'

class NewsletterMassUpload

  def self.process(file_name)
    raw_billing_user_data = SmarterCSV.process(file_name, {:downcase_header => false, :strings_as_keys => true})
    billing_user_hash = {}
    raw_billing_user_data.each do |user_hash|
      if user_hash["RatePlanCharge.Segment"] == user_hash["RatePlanCharge.Version"]
        billing_user_hash[user_hash["Account.AccountNumber"]] = user_hash
      end
    end 

    File.open("newsletter_mass_upload.csv", "w") do |file|
      file.puts "Subscription Code,Subscription Version,Account Number,Order Type,Order Name (Amendments Only),Change Description (Amendments only),Initial Term,Renewal Term,Term Commitment,AutoRenew,Term Start Date,Save As Draft,Contract Effective Date,Service Activation Date,Customer Acceptance Date,Cancel Subscription Date,Product SKU,Product Name,Rate Plan ID,Rate Plan Name,Rate Plan Component ID,Charge Name,Charge Description,Price,Quantity,# Periods to Prepay,Overage Included Units,Overage Price,Overage (Smoothing) # Periods,Accounting Code,Revenue Recognition Code,Revenue Recognition Trigger Date,Subscription Term Type,Overage Credit Back Option,Overage Credit Back Rate,Price Change Option,Price Increase Percentage,Use Discount Specific Accounting Code,Invoice Account Number,Destination Account Number,Destination Invoice Account Number,Usage Record Rating Option"
      billing_user_hash.each do |key, newsletter_hash|
        file.puts "#{newsletter_hash['Subscription.Name']},,,Remove a Product,Remove Newsletter Usage,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{newsletter_hash['Product.SKU']},SendGrid Add On Services,#{newsletter_hash['ProductRatePlan.Id']},Newsletter Usage,,Newsletter Usage,,,,,,,,,,,#{newsletter_hash['Subscription.TermType']},,,,,,,,,"
        file.puts "Prev,,,New Product,Marketing Email Service Change,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{newsletter_hash['Product.SKU']},SendGrid Add On Services,,Marketing Email Service,,Marketing Email Service Usage,Newsletter Service Usage,0.00025,,,,,,,,,#{newsletter_hash['Subscription.TermType']},,,,,,,,,"
        file.puts "Prev,,,,,,,,,,7/01/2013,,7/01/2013,7/01/2013,7/01/2013,,#{newsletter_hash['Product.SKU']},SendGrid Add On Services,,Marketing Email Service,,Marketing Email Service Usage,Newsletter Service Usage,0.00025,,,,,,,,,#{newsletter_hash['Subscription.TermType']},,,,,,,,,"        
      end
    end    
  end

end

NewsletterMassUpload.process(ARGV[0])