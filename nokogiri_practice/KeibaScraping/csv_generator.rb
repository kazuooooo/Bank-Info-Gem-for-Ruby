require 'csv'
require 'pry'

class CSVGenerator
  def generate_races_csv(races_data)
    # binding.pry
    races_data.each do |race_data|
      generate_race_csv(race_data)
    end
  end
  def generate_race_csv(race_data)
    CSV.open("race.csv", "a+"){|csv|
      csv << [ race_data.place, race_data.num, race_data.name ]
      csv << [ "着順", "馬番", "名前", "騎手名", "人気", "オッズ" ]
      race_data.result.each{|horce|
        csv << [ 
                 horce.ranking,
                 horce.number,
                 horce.name,
                 horce.jockey,
                 horce.popularity,
                 horce.odds
               ]
      }
    }
  end
end
