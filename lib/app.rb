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
  $report_file = File.new("../report.txt", "w+") #w+ allows reading/writing to file
end

def getTime
  time = Time.new
  time.strftime("%B %d %Y  %H:%M:%S")
end

def print_SalesReport_in_ascii
  # Print "Sales Report" in ascii art
  $report_file.puts"  _____       _            _____                       _"
  $report_file.puts" / ____|     | |          |  __ \\                     | |"
  $report_file.puts"| (___   __ _| | ___ ___  | |__) |___ _ __   ___  _ __| |_"
  $report_file.puts" \\___ \\ / _` | |/ _ \\ __| |  _  // _ \\ '_ \\ / _ \\| '__| __|"
  $report_file.puts" ____) | (_| | |  __\\__ \\ | | \\ \\  __/ |_) | (_) | |  | |_"
  $report_file.puts"|_____/ \\__,_|_|\\___|___/ |_|  \\_\\___| .__/ \\___/|_|   \\__|"
  $report_file.puts"                                    | |                   "
  $report_file.puts"                                    |_|"
end

def print_Products_in_ascii
  # Print "Products" in ascii art
  $report_file.puts "                     _            _       "
  $report_file.puts "                    | |          | |      "
  $report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  $report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  $report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  $report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  $report_file.puts "| |                                       "
  $report_file.puts "|_|                                       "
end

def print_Brands_in_ascii
  # Print "Brands" in ascii art (by Udacity's Ruby Nanodegree crew)
  $report_file.puts " _                         _     "
  $report_file.puts "| |                       | |    "
  $report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
  $report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
  $report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
  $report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
  $report_file.puts ''
end

# takes an array of as a parameter
def total_number_of_purchases(toyPurchases)
  toyPurchases.count
end

# parameter is an array of hashes
def total_amount_of_sales(toyPurchases)
  toyPurchases.inject(0){|sum, addit| sum.to_f + addit["price"].to_f}
end

# parameter is an array of hashes
def avg_selling_price(toyPurchases)
  total_amount_of_sales(toyPurchases)/total_number_of_purchases(toyPurchases)
end

# returns an array with the amount each person saved (comparing "price" with "full-price")
def amount_saved(retail, toyPurchases)
  individual_savings = Array.new
  toyPurchases.each do |purch|
    individual_savings.push(retail - purch["price"])
  end
  return individual_savings
end

def sortByBrand
  $products_hash['items'].sort_by do |i|
    i['brand']
  end
end

def generate_array_brand_names
  $products_hash['items'].map {|toys| toys['brand']}.uniq
end 

def write_products_report(title, retailPrice, amount_of_purchases, sales_Profit,
                          average_sale, averageDiscount_dollars,
                          averageDiscount_percentage)
  $report_file.puts "~~~ #{title} ~~~"
  $report_file.puts "Retail price: #{retailPrice}"
  $report_file.puts "Total number of purchases: #{amount_of_purchases}"
  $report_file.puts "Total amount of sales: #{sales_Profit}"
  $report_file.puts "Average price sold for: #{average_sale}"
  $report_file.puts "Average discount: $#{averageDiscount_dollars}
                      (or %#{averageDiscount_percentage.round(2)})"
  $report_file.puts ''
end

def generate_products_stats
  $products_hash['items'].each do |toy|
    retailPrice = toy['full-price'].to_f
    amount_of_purchases = total_number_of_purchases(toy['purchases'])
    sales_Profit = total_amount_of_sales(toy['purchases']).to_f
    average_sale = avg_selling_price(toy['purchases'])
    averageDiscount_dollars = (retailPrice*amount_of_purchases - sales_Profit)/amount_of_purchases;
    averageDiscount_percentage = (averageDiscount_dollars/retailPrice)*100
    write_products_report(toy['title'], retailPrice, amount_of_purchases, sales_Profit,
                              average_sale, averageDiscount_dollars, averageDiscount_percentage)
  end
end

def sum_toy_sales(toy)
#  sales_volume = 0
  sales_volume = toy['purchases'].inject(0){|runningTotal, item| runningTotal + item['price']}

#  toy['purchases'].each do |purchase|
#    sales_volume += purchase['price']
#  end
  return sales_volume
end

def write_brands_report(current_brand, stock, average_brand_price, sales_volume)
  $report_file.puts "~~~ #{current_brand} ~~~"
  $report_file.puts "Stock: #{stock}"
  $report_file.puts "Average price of toys: #{average_brand_price}"
  $report_file.puts "Total sales volume: #{sales_volume.round(2)}"
  $report_file.puts ''
end

def generate_brands_stats(products_brandOrdered, stock, full_price_sum, sales_volume)
  current_brand = products_brandOrdered[0]['brand']
  distinct_toy_count = 0 # used in calculating average retail price for a brand's toy
  products_brandOrdered.each { |toy|
    if toy['brand'].eql? current_brand
      stock += toy['stock'].to_i
      distinct_toy_count += 1
      full_price_sum += toy['full-price'].to_f
      sales_volume += sum_toy_sales(toy)
    else # encountering new brand info
      average_brand_price = full_price_sum.round(2)/distinct_toy_count
      write_brands_report(current_brand, stock, average_brand_price, sales_volume)
      current_brand = toy['brand']
      stock = toy['stock'].to_i
      distinct_toy_count = 1 # resetting since new brand
      full_price_sum = toy['full-price'].to_f
      sales_volume = sum_toy_sales(toy) # reset for new brand
    end # if-else
  } #products_by_brand.each

  # writing info for final brand
  average_brand_price = full_price_sum.round(2)/distinct_toy_count
  write_brands_report(current_brand, stock, average_brand_price, sales_volume)
end

def create_report
  # Time when report is created
  $report_file.puts getTime
  print_SalesReport_in_ascii
  # For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price
  print_Products_in_ascii
  generate_products_stats
  # For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total sales volume of all the brand's toys combined
  print_Brands_in_ascii
  #items_in_brand_order = sortByBrand
  brands = generate_array_brand_names
  puts brands
  stock = 0
  full_price_sum = 0
  sales_volume = 0
  items_in_brand_order.each do |toy|
    generate_brands_stats(items_in_brand_order, stock, full_price_sum, sales_volume)
  end
end # create_report()

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start