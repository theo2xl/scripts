require 'smarter_csv'

class NewsletterMassUpload

  def self.process(file_name)
    courtney_arr = Array.new()
    courtney_arr << 416857 << 157591 << 770947 << 767905 << 777406 << 24091 <<778609 << 18871 << 666736 << 78312

    marketing_ids = SmarterCSV.process("marketing_ids.csv", {:downcase_header => false, :strings_as_keys => true})
    marketing_id_hash = {}
    marketing_ids.each do |marketing_id|
      marketing_id_hash[marketing_id["Marketing_Id"]] = marketing_id["Marketing_Id"]
    end

    raw_billing_user_data = SmarterCSV.process(file_name, {:downcase_header => false, :strings_as_keys => true})
    billing_user_hash = {}
    raw_billing_user_data.each do |user_hash|
      if user_hash["RatePlanCharge.Segment"] == user_hash["RatePlanCharge.Version"]
        unless user_hash["ProductRatePlanCharge.Name"] == "Newsletter Usage Discount"
          unless courtney_arr.include?(user_hash["Account.AccountNumber"])
            billing_user_hash[user_hash["Account.AccountNumber"]] = user_hash

#             unless marketing_id_hash.has_key?(user_hash["Account.AccountNumber"])
# p user_hash["Account.AccountNumber"]
#             end
          end
        end
      end
    end 

    File.open("newsletter_mass_upload.csv", "w") do |file|
      file.puts "Subscription Code,Subscription Version,Account Number,Order Type,Order Name (Amendments Only),Change Description (Amendments only),Initial Term,Renewal Term,Term Commitment,AutoRenew,Term Start Date,Save As Draft,Contract Effective Date,Service Activation Date,Customer Acceptance Date,Cancel Subscription Date,Product SKU,Product Name,Rate Plan ID,Rate Plan Name,Rate Plan Component ID,Charge Name,Charge Description,Price,Quantity,# Periods to Prepay,Overage Included Units,Overage Price,Overage (Smoothing) # Periods,Accounting Code,Revenue Recognition Code,Revenue Recognition Trigger Date,Subscription Term Type,Overage Credit Back Option,Overage Credit Back Rate,Price Change Option,Price Increase Percentage,Use Discount Specific Accounting Code,Invoice Account Number,Destination Account Number,Destination Invoice Account Number,Usage Record Rating Option"
      billing_user_hash.each do |key, newsletter_hash|
        file.puts "#{newsletter_hash['Subscription.Name']},,,Remove a Product,Remove Marketing Email Service,,,,,,9/01/2013,,9/01/2013,9/01/2013,9/01/2013,,#{newsletter_hash['Product.SKU']},SendGrid Add On Services,#{newsletter_hash['ProductRatePlan.Id']},Newsletter Usage,,Newsletter Usage,,,,,,,,,,,#{newsletter_hash['Subscription.TermType']},,,,,,,,,"
        file.puts "Prev,,,,,,,,,,9/01/2013,,9/01/2013,9/01/2013,9/01/2013,,#{newsletter_hash['Product.SKU']},SendGrid Add On Services,,Newsletter Usage,,Newsletter Usage,,0,1,,10000,0.00025,,,,,#{newsletter_hash['Subscription.TermType']},,,,,,,,,"

        file.puts "Prev,,,New Product,Add Newsletter Usage,,,,,,9/01/2013,,9/01/2013,9/01/2013,9/01/2013,,#{newsletter_hash['Product.SKU']},SendGrid Add On Services,,Newsletter Usage,,Newsletter Usage,,0,1,,10000,0.00025,,,,,#{newsletter_hash['Subscription.TermType']},,,,,,,,,"
        file.puts "Prev,,,,,,,,,,9/01/2013,,9/01/2013,9/01/2013,9/01/2013,,#{newsletter_hash['Product.SKU']},SendGrid Add On Services,,Newsletter Usage,,Newsletter Usage Discount,,,,,,,,,,,#{newsletter_hash['Subscription.TermType']},,,,,,,,,"
      end
    end    
  end

end

NewsletterMassUpload.process(ARGV[0])