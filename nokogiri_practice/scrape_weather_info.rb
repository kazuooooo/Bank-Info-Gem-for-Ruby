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

doc.xpath('//table[@class="yjw_table"]//small').each do |node|
  # title
  p node.inner_text
end