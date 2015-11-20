require 'pry'
require 'open-uri'
require 'nokogiri'
require './race.rb'
require './horce.rb'
require './race_url_converter'
require 'yard'

class RaceScraper

  # レース一覧ページからレース情報をスクレイピングしてRaceオブジェクトの配列で返す
  # @param [String] place 競馬場を指定('tokyo' or 'kyoto' or 'fukushima')
  # @return [Race[]] races Raceオブジェクトの配列 
  def scrape_race_from_list(place)
    race_url_converter = RaceURLConverter.new
    list_url = race_url_converter.get_race_list_url(place)
    races = []
    parsed_doc = get_parsed_doc(list_url)
    nodeset = parsed_doc.css('table.scheLs td.wsLB a')
    race_count = 1
    nodeset.each do |node|
      race = scrape_race(place, race_count)
      races.push(race)
      race_count += 1
    end
    return races;
  end

  # レース一結果ページからレース情報をスクレイピングしてRaceオブジェクトを返す
  # @param [String] place 競馬場を指定('tokyo' or 'kyoto' or 'fukushima')
  # @return [Race] race Raceオブジェクト
  def scrape_race(place, num)
    race_url_converter = RaceURLConverter.new
    race_url = race_url_converter.convert_race_to_url(place, num)
    # スクレイピングの準備
    parsed_doc = get_parsed_doc(race_url)
    # レースオブジェクトを生成
    race = Race.new
    # 場所を取得
    race_place_desc = parsed_doc.css('#raceTitDay').inner_text
    race_place_desc.match(/(東京|福島|京都)/) do |md|
      race.place = md[0]
    end
    # 何レース目かを取得
    race.num = parsed_doc.css('#raceNo').inner_text
    # レース名を取得
    race.name = parsed_doc.css('h1.fntB').inner_text.gsub(/[\n]/,'')
    # レース結果を取得
    race.result = scrape_race_result(parsed_doc)
    return race
  end

  # 指定したページのHTMLをパースして返す
  # @param [String] url パースしたいページのURL
  # @return [Object] parsed_doc パースしたオブジェクト
  def get_parsed_doc(url)
    #　スクレイピング先のURL
    url = url
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数に渡す
    end
    # 解析したhtmlを返す
    return Nokogiri::HTML.parse(html,charset)
  end

  private
  # レース結果ページをスクレイピングしてhorceオブジェクトの各値に値を入れていく
  # @param [Object] parsed_doc レース結果のページをパースしたオブジェクト
  # @return [Horce[]] horces Horceオブジェクトの配列
  def scrape_race_result(parsed_doc)
    # horceの配列
    horces = []
    # テーブルの列を取得
    nodeset = parsed_doc.css('table#resultLs tr')
    # 最初と最後はヘッダー行なので削除
    nodeset.shift 
    nodeset.pop
    # horceに各値を入れていく
    nodeset.each do |node|
      horce = Horce.new
      horce.ranking = node.css('td')[0].inner_text.gsub(/[\n]/,'') # 順位
      horce.number = node.css('td')[1].inner_text # 馬番
      horce.name = node.css('td')[3].inner_text # 馬名
      horce.jockey = node.css('td')[5].inner_text # 騎手名
      horce.popularity = node.css('td')[12].inner_text # 人気順
      horce.odds = node.css('td')[13].inner_text # オッズ
      horces.push(horce)
    end
    # resultsを返す
    return horces
  end

end