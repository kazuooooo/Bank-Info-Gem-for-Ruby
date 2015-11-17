require 'open-uri'
require 'nokogiri'

# スクレイピング先のURL
url = 'http://weather.yahoo.co.jp/weather/13/4410.html'

charset = nil
html = open(url) do |f|
  charset = f.charset #文字種別を取得
  f.read #htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してObjectを作成
doc = Nokogiri::HTML.parse(html, charset)
# 取得したいtrを

#tr要素をxpathで探す
doc.xpath('//table[@class="yjw_table"]//tr').each do |node|
  #さらにその中のsmall要素を探す
  node.xpath('.//td/small').each do |cnode|
    p cnode.inner_text
  end
end

doc.css('table.yjw_table tr').each do |node|
  #さらにその中のsmall要素を探す
  node.css('td small').each do |cnode|
    p cnode.inner_text
  end
end