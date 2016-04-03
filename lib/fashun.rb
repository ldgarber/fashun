require 'open-uri'
require 'Nokogiri'
require 'fashun/product'

class Fashun
  attr_reader :madewell, :products, :products_names

  DOMAINS = [
    "https://www.madewell.com/search2/index.jsp?N=0&Nloc=en&Ntrm=%s&Npge=1&Nrpp=150&Nsrt=0&hasSplitResults=false" 
  ]

  def self.generate_domains(search_term)
    search_term = search_term.split(" ").map {|item| item.strip}.join("%20")
    search_domains = []
    DOMAINS.each do |domain|
      search_domains << domain % [search_term] 
    end
    search_domains
  end 

  def self.search(search_term)
    @domains = self.generate_domains(search_term)
    @madewell = @domains[0]
    @madewell_doc = Nokogiri::HTML(open("#{@madewell}"))
    @product_links = @madewell_doc.css('.product-item .product-name a')
    puts @product_links.length
    @products = []
    @product_links.each_with_index do |link, index|
      prod = Product.new(link.text, link["href"])
      prod.id = index + 1
      @products << prod 
    end
    
    self.print_product_list

    puts "Enter a number for more information about the product, or press any other key to exit"
    input = STDIN.gets.chomp.to_i
    if input.between?(1, @products.length)
      self.detailed_search(input)
    end

  end 

  def self.detailed_search(index) 
    puts @products[index - 1].name
    @products[index - 1].details
  end

  def self.print_product_list
    @products.each_with_index do |product, i|
      puts "#{i + 1}. #{product.name}"
    end
  end
  
end
