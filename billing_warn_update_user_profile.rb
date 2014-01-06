require 'csv'

class BillingWarnUpdateUserProfile

  def self.process(file_name)
    billing_warn_array = Array.new

    CSV.foreach("#{file_name}.csv") do |row|
      billing_warn_array << row[0] unless billing_warn_array.include?(row[0])
    end

    p billing_warn_array.join(',')
  end

end

BillingWarnUpdateUserProfile.process(ARGV[0])