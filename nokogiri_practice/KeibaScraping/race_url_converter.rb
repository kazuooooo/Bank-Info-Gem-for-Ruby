require 'nokogiri'

class RaceURLConverter

  def convert_race_to_url(place, num)
    race_list_url = get_race_list_url(place)
    race_url = get_race_url(race_list_url, num)
  end

  def get_race_list_url(place)
    case place
      when 'tokyo' then
        return 'http://keiba.yahoo.co.jp/race/list/15050502/'
      when 'kyoto' then
        return 'http://keiba.yahoo.co.jp/race/list/15080502/'
      when 'fukushima' then
        return 'http://keiba.yahoo.co.jp/race/list/15030304/'
    end  
  end

  def get_race_url(race_list_url, num)
    #:TODO Refactorring
    race_scraper = RaceScraper.new
    parsed_doc = race_scraper.get_parsed_doc(race_list_url)
    node = parsed_doc.css('table.scheLs td.wsLB a')[num - 1]
    url = 'http://keiba.yahoo.co.jp'.concat(node['href'])
  end
end
