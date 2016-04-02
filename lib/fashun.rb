require 'open-uri'
require 'Nokogiri'

class Fashun
  DOMAINS = [
    "https://www.madewell.com/search2/index.jsp?N=0&Nloc=en&Ntrm=%s&Npge=1&Nrpp=100&Nsrt=0&hasSplitResults=false" 
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
    products = @madewell_doc.css('.product-item .product-name')
    products_names = products.text.split("\n")
    products_names.delete_if {|name| name.strip! =="" }
    products_names.each_with_index do |name, i|
      puts "#{i + 1}. #{name}"
    end
  end 
end
