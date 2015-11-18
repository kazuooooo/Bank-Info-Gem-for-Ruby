require 'pry'
require 'open-uri'
require 'nokogiri'
require './race-result.rb'
require './horce-result.rb'

class KeibaResultScraper 
  
  def initialize
    setup_scraping
    scrape_race
  end
  
  def setup_scraping
    #　スクレイピング先のURL
    url = 'http://keiba.yahoo.co.jp/race/result/1505040911/'
    charset = nil
    html = open(url) do |f|
      charset = f.charset #文字種別を取得
      f.read #htmlを読み込んで変数に渡す
    end
    # htmlを解析してObjectを作成
    @@doc = Nokogiri::HTML.parse(html,charset)
  end

  def scrape_race
    # レースオブジェクトを生成
    race = RaceResult.new
    # 場所を取得
    race_place_desc = @@doc.css('#raceTitDay').inner_text
    race_place_desc.match(/(東京|福島|京都)/) do |md|
    race.place = md[0]
    end
    # 何レース目かを取得
    race.num = @@doc.css('#raceNo').inner_text
    # レース名を取得
    race.name = @@doc.css('h1.fntB').inner_text.gsub(/[\n]/,"")
    scrape_race_result
  end

  def scrape_race_result
    # horce_resultの配列
    horce_results = []
    # テーブルの列を取得
    nodeset = @@doc.css('table#resultLs tr')
    # 最初と最後はヘッダー行なので削除
    nodeset.shift
    nodeset.pop
    # horce_resultに各値を入れていく
    nodeset.each do |node|
      horce_result = HorceResult.new
      horce_result.ranking = node.css('td')[0].inner_text.gsub(/[\n]/,"") # 順位
      horce_result.number = node.css('td')[3].inner_text # 馬番
      horce_result.name = node.css('td')[4].inner_text # 馬名
      horce_result.jockey = node.css('td')[5].inner_text # 騎手名
      horce_result.popularity = node.css('td')[12].inner_text # 人気順
      horce_result.odds = node.css('td')[13].inner_text # オッズ
      horce_results.push(horce_result)
    end
    # resultsを返す
    return horce_results
  end
end