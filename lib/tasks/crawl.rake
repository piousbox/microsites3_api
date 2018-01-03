
def puts! a, b=''
  puts "+++ +++ #{b}"
  puts a.inspect
end

def process_page page, args={}
  profile   = args[:profile] || IshModels::UserProfile.find_by :email => 'piousbox@gmail.com'
  tag       = args[:tag] || :unknown_scraped_tag
  companies = page.css(".layout.xs-ptb1.xs-m0")
  companies.each_with_index do |company, idx|
    name = company.css('span')[0].text
    location = company.css('span')[1].text
    lead = Ish::Lead.new :tag => tag, :location => location, :company => name, :profile => profile
    if lead.save
      print "#{idx+1}."
    else
      puts lead.errors.messages
      puts lead.inspect
    end
  end
  puts ""
end

namespace :crawl do

  desc "hired react companies"
  task :hired_com_react => :environment do
    result = HTTParty.get "https://hired.com/companies/react?page=1"
    page = Nokogiri::HTML(result.body)
    pagelinks = page.css(".page.xs-epsilon.sm-prlh0>a")
    n_pages = pagelinks.map( &:text ).max.to_i
    profile = IshModels::UserProfile.find_by :email => 'piousbox@gmail.com'

    print "page 1: "
    process_page page, profile

    (2..n_pages).each do |pagenum|
      sleep 2
      print "page #{pagenum}: "
      page = Nokogiri::HTML( HTTParty.get "https://hired.com/companies/react?page=#{pagenum}" )
      process_page page, { :profile => profile, :tag => :hired_com_react }
    end
  end

  desc "hired ror companies"
  task :hired_com_ror => :environment do
    result = HTTParty.get "https://hired.com/companies/ruby-on-rails?page=1"
    page = Nokogiri::HTML(result.body)
    pagelinks = page.css(".page.xs-epsilon.sm-prlh0>a")
    n_pages = pagelinks.map( &:text ).max.to_i
    profile = IshModels::UserProfile.find_by :email => 'piousbox@gmail.com'

    print "page 1: "
    process_page page, profile

    (2..n_pages).each do |pagenum|
      sleep 2
      print "page #{pagenum}: "
      page = Nokogiri::HTML( HTTParty.get "https://hired.com/companies/ruby-on-rails?page=#{pagenum}" )
      process_page page, { :profile => profile, :tag => :hired_com_ror }
    end
  end

end