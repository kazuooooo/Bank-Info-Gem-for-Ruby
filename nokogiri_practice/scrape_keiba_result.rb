require 'open-uri'
require 'nokogiri'

#　スクレイピング先のURL
url = 'http://keiba.yahoo.co.jp/race/result/1505040911/'

charset = nil
html = open(url) do |f|
  charset = f.charset #文字種別を取得
  f.read #htmlを読み込んで変数に渡す
end

# htmlを解析してObjectを作成
doc = Nokogiri::HTML.parse(html,charset)

doc.css('table#resultLs tr').each do |node|
   p '着順' + node.css('td.txC:nth-child(1)').inner_text
   p '枠番' + node.css('td.txC span[class^="wk"]').inner_text
   p '馬番' + node.css('td.txC:nth-child(3)').inner_text
   p '馬名' + node.css('td.fntN.txL a').inner_text
   p '性齢' + node.css('td.txL:nth-child(5)').inner_text
   p 'タイム' + node.css('td:nth-child(7)').inner_text
   p '人気' + node.css('td:nth-child(13)').inner_text
   p 'オッズ' + node.css('td:nth-child(14)').inner_text
end


