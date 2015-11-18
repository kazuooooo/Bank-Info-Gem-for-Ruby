require './race_scraper.rb'
scraper = RaceScraper.new
scraper.scrape_race('http://keiba.yahoo.co.jp/race/result/1505040911/')

# レースのURLを指定してレースの情報を取得できる

# その中にある馬の各パラメータから検索して、horce_resultを取得できる