class Fashun
  def self.hi
    puts "Fashun!"
  end

  def self.search(search_term)
    search_term = search_term.split(" ").map {|item| item.strip}.join("%20")
  end 
end
