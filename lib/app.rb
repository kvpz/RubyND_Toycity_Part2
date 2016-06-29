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

def sort_by_brand()
  $products_hash["items"].sort_by{|i| i["brand"]}
end

def create_report
  # Print "Sales Report" in ascii art
  $report_file.puts ""
  $report_file.puts "/"
  $report_file.puts "|"
  $report_file.puts "\\ _"
  $report_file.puts "   |"
  $report_file.puts "_ _/"
  $report_file.puts ""

  # Print today's date
  time = Time.new
  $report_file.puts time.strftime("%B %d, %Y")

  # Print "Products" in ascii art
  $report_file.puts ""
  $report_file.puts " _ _   _ _     _ _    _ _           _   _ _ _       "
  $report_file.puts "|   \\ |   \\   /   \\  |   \\ |    |  /  \\   |   /-\\   "
  $report_file.puts "| _ / |_  /  /     \\ |   | |    |  |      |  |           "
  $report_file.puts "|     |  \\   \\     / |   | |    |  |      |   \\        "
  $report_file.puts "|     |   \\   \\_ _/  |_ _/  \\_ _/  \\ _/   |  \\-/     "
  $report_file.puts ""

  # For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price

  $products_hash["items"].each do |toy|
    toyName = toy["title"]
    retailPrice = toy["full-price"].to_f
    amount_sold = total_number_of_purchases(toy["purchases"])
    sales_Profit = total_amount_of_sales(toy["purchases"]).to_f
    average_sale = avg_selling_price(toy["purchases"])
    averageDiscount_dollars = (retailPrice*amount_sold - sales_Profit)/amount_sold;
    averageDiscount_percentage = (averageDiscount_dollars/retailPrice)*100
    $report_file.puts "~~~ #{toyName} ~~~"
    $report_file.puts "Retail price: #{retailPrice}"
    $report_file.puts "Total number of purchases: #{amount_sold}"
    $report_file.puts "Total amount of sales: #{sales_Profit}"
    $report_file.puts "Average price sold for: #{average_sale}"
    $report_file.puts "Average discount: $#{averageDiscount_dollars} (or %#{averageDiscount_percentage.round(2)})"
    $report_file.puts ""
  end

  # Print "Brands" in ascii art (by Udacity's Ruby Nanodegree crew)
  $report_file.puts " _                         _     "
  $report_file.puts "| |                       | |    "
  $report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
  $report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
  $report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
  $report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
  $report_file.puts ""

  # For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total sales volume of all the brand's toys combined

  # obtain an array containing the list of items sorted by brand
  products_by_brand = sort_by_brand()
  brands_available = Array.new(0,products_by_brand[0]["brand"]) # to store all brand names (alphabetical order)
  itr = 0 # used to iterate though the array brands_available
  products_by_brand.each do |toy|
    currentBrand = toy["brand"]
    if(currentBrand != brands_available[itr])
      itr += 1
      brands_available[itr] = currentBrand
    end
  end
  puts brands_available

end #create_report





def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start