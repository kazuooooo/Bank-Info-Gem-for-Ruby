require 'nokogiri'
require 'yard'

class RaceURLConverter

  # レースの場所とレース番号からレース結果のURLを取得
  # @param [String] place 競馬場を指定('tokyo' or 'kyoto' or 'fukushima')
  # @param [Int] num 第何レースかを指定
  # @return [String] race_url レース結果のURL
  def convert_race_to_url(place, num)
    race_list_url = get_race_list_url(place)
    race_url = get_race_url(race_list_url, num)
  end

  # レースの場所からレース一覧のURLを取得
  # @param [String] place 競馬場を指定('tokyo' or 'kyoto' or 'fukushima')
  # @return race_list_url レース一覧のURL
  def get_race_list_url(place)
    case place
      when 'tokyo' then
        return 'http://keiba.yahoo.co.jp/race/list/15050502/'
      when 'kyoto' then
        return 'http://keiba.yahoo.co.jp/race/list/15080502/'
      when 'fukushima' then
        return 'http://keiba.yahoo.co.jp/race/list/15030304/'
      else
        raise ArgumentError, "Please Input existing place 'tokyo' or 'kyoto' or 'fukushima'"
    end  
  end

  # レースの場所からレース一覧のURLを取得
  # @param [String] race_list_url レース一覧のURL
  # @param [Int] num 第何レースかを指定
  # @return url レース結果のURL
  def get_race_url(race_list_url, num)
    #:TODO Refactorring
    race_scraper = RaceScraper.new
    parsed_doc = race_scraper.get_parsed_doc(race_list_url)
    node = parsed_doc.css('table.scheLs td.wsLB a')[num.to_i - 1]
    url = 'http://keiba.yahoo.co.jp'.concat(node['href'])
  end
end
