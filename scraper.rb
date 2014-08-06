require "rubygems"
require "nokogiri"
require "open-uri"

page = Nokogiri::HTML(open("http://mtgimage.com/setname/"))

total = page.css("a").count

puts "SET;CARD;IMAGE;\n"

page.css("a").each do |set|
  if set.text != "../"
    begin
      set_page = Nokogiri::HTML(open("http://mtgimage.com/setname/#{set['href']}"))

      total_cards = set_page.css("a").count
      cards = []
      set_page.css("a").each do |card|
        next if card.text == "../"

        card_title = card.text.split(".").first
        card_image = "http://mtgimage.com/setname/#{set['href']}#{card_title.gsub(' ', '%20')}.hq.jpg"

        unless cards.include? card_title
          puts "#{set.text.gsub('/', '')};#{card_title};#{card_image};\n"

          cards << card_title
        end
      end
    rescue
      #puts set.text.gsub('/', '')
    end
  end
end