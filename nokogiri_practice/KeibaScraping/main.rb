require './race_scraper.rb'
require './csv_generator.rb'
require 'pry'
require 'csv'

scraper = RaceScraper.new
csv_generator = CSVGenerator.new
# Race一覧からRace情報を取得
races = scraper.scrape_race_from_list('tokyo')
binding.pry
p races
# csvで出力
#p scraper.scrape_race('tokyo',3)
# csv_generator.generate_races_csv(races)
