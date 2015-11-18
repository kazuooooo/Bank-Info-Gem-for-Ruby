require 'pry'
require 'open-uri'
require 'nokogiri'
require './race.rb'
require './horce.rb'

class RaceScraper

  def scrape_race(race_url)
    # スクレイピングの準備
    setup_scraping(race_url)
    # レースオブジェクトを生成
    race = Race.new
    # 場所を取得
    race_place_desc = @doc.css('#raceTitDay').inner_text
    race_place_desc.match(/(東京|福島|京都)/) do |md|
    race.place = md[0]
    end
    # 何レース目かを取得
    race.num = @doc.css('#raceNo').inner_text
    # レース名を取得
    race.name = @doc.css('h1.fntB').inner_text.gsub(/[\n]/,"")
    # レース結果を取得
    race.result = scrape_race_result
  end

  private

  def setup_scraping(race_url)
    binding.pry
    #　スクレイピング先のURL
    url = race_url
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数に渡す
    end
    # htmlを解析してObjectを作成
    @doc = Nokogiri::HTML.parse(html,charset)
  end

  def scrape_race_result
    # horceの配列
    horces = []
    # テーブルの列を取得
    nodeset = @doc.css('table#resultLs tr')
    # 最初と最後はヘッダー行なので削除
    nodeset.shift 
    nodeset.pop
    # horceに各値を入れていく
    nodeset.each do |node|
      horce = Horce.new
      horce.ranking = node.css('td')[0].inner_text.gsub(/[\n]/,"") # 順位
      horce.number = node.css('td')[3].inner_text # 馬番
      horce.name = node.css('td')[4].inner_text # 馬名
      horce.jockey = node.css('td')[5].inner_text # 騎手名
      horce.popularity = node.css('td')[12].inner_text # 人気順
      horce.odds = node.css('td')[13].inner_text # オッズ
      horces.push(horce)
    end
    # resultsを返す
    p horces
    return horces
  end

end