require 'csv'
require 'pry'
require 'yard'

class CSVGenerator
  
  # Raceの一覧のCSVを生成 (ファイル名：race.csv)
  # @param [Race[]] races_data Raceオブジェクトの配列
  # @return [nil]
  def generate_races_csv(races_data)
    races_data.each do |race_data|
      generate_race_csv(race_data)
    end
  end

  # RaceのCSVを生成 (ファイル名：race.csv)
  # @param [Race] race_data Raceオブジェクト
  # @return [nil]
  def generate_race_csv(race_data)
    CSV.open('race.csv', 'a+') do |csv|
      csv << [ race_data.place, race_data.num, race_data.name ]
      csv << [ '着順', '馬番', '名前', '騎手名', '人気', 'オッズ' ]
      race_data.result.each do |horce|
        csv << [ 
          horce.ranking,
          horce.number,
          horce.name,
          horce.jockey,
          horce.popularity,
          horce.oddsm
        ]
      end
    end
  end

end