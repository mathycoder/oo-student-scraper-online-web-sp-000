require 'open-uri'
require 'pry'

class Scraper
  
  def self.scrape_index_page(index_url)
    profiles_array = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    profiles = doc.css(".student-card")
    profiles.each do |profile|
      profiles_array << {
      :name => profile.css("h4.student-name").text,
      :location => profile.css("p.student-location").text,
      :profile_url => profile.css("a").attribute("href").value
      }
    end
    profiles_array
  end

  def self.scrape_profile_page(profile_url)
    
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    social = doc.css("div.social-icon-container a")
    social_urls = [] 
    social.each do |link|
      social_urls << link.attribute("href").text
    end 
    my_hash = {
      :blog => social_urls.find{ |s| !s.include?('twitter') && !s.include?('github') && !s.include?('youtube') && !s.include?('linkedin') },
    :twitter => social_urls.find { |s| s.include?('twitter')},
    :linkedin => social_urls.find { |s| s.include?('linked')},
    :github => social_urls.find { |s| s.include?('github') },
    :bio => doc.css(".description-holder p").text, :profile_quote => doc.css(".profile-quote").text, 
    }
    my_hash.delete_if {|key, value| value == nil }
  end

end

