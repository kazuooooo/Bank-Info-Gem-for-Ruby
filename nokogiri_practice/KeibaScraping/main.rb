require './race_scraper.rb'
require './csv_generator.rb'
require 'pry'
require 'csv'

scraper = RaceScraper.new
csv_generator = CSVGenerator.new
# Race一覧からRace情報を取得
races = scraper.scrape_race_from_list('http://keiba.yahoo.co.jp/race/list/15080409/')
# csvで出力
csv_generator.generate_races_csv(races)
