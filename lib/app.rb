=begin
  Kevin Perez
  6/28/16
  Udacity Nanodegree Project 3: ToyCity Report Generator 2

=end

require 'json'
def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+") #w+ allows reading/writing to file
end


def start
  setup_files # load, read, parse, and create the files
  #create_report # create the report!
end

# Print "Sales Report" in ascii art
puts ""
puts "/"
puts "|"
puts "\\ _"
puts "   |"
puts "_ _/"
puts ""
# Print today's date
time = Time.new
puts time.strftime("%B %d, %Y")

# Print "Products" in ascii art
puts ""
puts " _ _   _ _     _ _    _ _           _   _ _ _       "
puts "|   \\ |   \\   /   \\  |   \\ |    |  /  \\   |   /-\\   "
puts "| _ / |_  /  /     \\ |   | |    |  |      |  |           "
puts "|     |  \\   \\     / |   | |    |  |      |   \\        "
puts "|     |   \\   \\_ _/  |_ _/  \\_ _/  \\ _/   |  \\-/     "
puts ""


# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price

start

def total_number_of_purchases(toyPurchases)
  toyPurchases.count
end

def total_amount_of_sales(toyPurchases)
  toyPurchases.inject(0){|sum, addit| sum.to_f + addit["price"].to_f}
end

def avg_selling_price(toyPurchases)
  total_amount_of_sales(toyPurchases)/total_number_of_purchases(toyPurchases)
end

#returns an array with the amount each person saved (comparing "price" with "full-price")
def amount_saved(retail, toyPurchases)
  individual_savings = Array.new
  toyPurchases.each do |purch|
    individual_savings.push(retail - purch["price"])
  end
  return individual_savings
end

$products_hash["items"].each do |toy|
  toyName = toy["title"]
  retailPrice = toy["full-price"].to_f
  amount_sold = total_number_of_purchases(toy["purchases"])
  sales_Profit = total_amount_of_sales(toy["purchases"]).to_f
  average_sale = avg_selling_price(toy["purchases"])
  averageDiscount_dollars = (retailPrice*amount_sold - sales_Profit)/amount_sold;
  averageDiscount_percentage = (averageDiscount_dollars/retailPrice)*100
  puts toyName
  puts "Retail price: #{retailPrice}"
  puts "Total number of purchases: #{amount_sold}"
  puts "Total amount of sales: #{sales_Profit}"
  puts "Average price sold for: #{average_sale}"
  puts "Average discount: $#{averageDiscount_dollars} (or %#{averageDiscount_percentage.round(2)})"
  puts ""

end
# Print "Brands" in ascii art

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined
