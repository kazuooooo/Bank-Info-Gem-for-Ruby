require './race_scraper.rb'
require 'pry'

scraper = RaceScraper.new
# レースのURLを指定してレースの情報を取得できる
# race = scraper.scrape_race('http://keiba.yahoo.co.jp/race/result/1505040901/')
 races = scraper.scrape_race_from_list('http://keiba.yahoo.co.jp/race/list/15080409/')
# その中にある馬の各パラメータから検索して、horce_resultを取得できる