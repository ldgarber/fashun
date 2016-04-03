require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Product
  attr_accessor :name, :link, :id, :prod_details, :price

  def initialize(name, link)
    @name = name
    @link = link
    @id = 0
    @price = nil
    @prod_details = nil
  end
  
  def details
    @doc = Nokogiri::HTML(open("#{@link}"))
    @prod_details = @doc.css("#prodDtlBody").text.strip
    puts @prod_details
  end
end
