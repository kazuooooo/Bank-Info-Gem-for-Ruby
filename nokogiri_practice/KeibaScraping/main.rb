require './race_scraper.rb'
require './csv_generator.rb'
require 'pry'
require 'csv'

scraper = RaceScraper.new
csv_generator = CSVGenerator.new

race = scraper.scrape_race('tokyo',3)
races = scraper.scrape_race_from_list('tokyo')

csv_generator.generate_races_csv(races)
csv_generator.generate_race_csv(race)
