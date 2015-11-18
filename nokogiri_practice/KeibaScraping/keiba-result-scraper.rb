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
    race_obj = RaceResult.new
    # 場所を取得
    race_place_desc = @@doc.css('#raceTitDay').inner_text
    race_place_desc.match(/(東京|福島|京都)/) do |md|
      race_obj.place = md[0]
    end
    # 何レース目かを取得
    race_obj.race_num = @@doc.css('#raceNo').inner_text
    # レース名を取得
    race_obj.race_name = @@doc.css('h1.fntB').inner_text.gsub(/[\n]/,"")
    scrape_race_result
  end

  def scrape_race_result
    # テーブルの列を取得
    nodeset = @@doc.css('table#resultLs tr')
    # 最初と最後はヘッダー行なので削除
    nodeset.shift
    nodeset.pop
    # horce_resultに各値を入れていく
    nodeset.each do |node|
      p '着順' + node.css("td.txC:nth-child(1)").inner_text
      # p '枠番' + node.css('td.txC span[class^="wk"]').inner_text
      # p '馬番' + node.css('td.txC:nth-child(3)').inner_text
      # p '馬名' + node.css('td.fntN.txL a').inner_text
      # p '性齢' + node.css('td.txL:nth-child(5)').inner_text
      # p 'タイム' + node.css('td:nth-child(7)').inner_text
      # p '人気' + node.css('td:nth-child(13)').inner_text
      # p 'オッズ' + node.css('td:nth-child(14)').inner_text
    end
  end
end