require 'json'

#
# JSON data for superheroes and their powers based on Claudio Davi's Kaggle dataset
# https://www.kaggle.com/datasets/claudiodavi/superhero-set/
#
# Mainly I converted it from CSV to JSON
#

class Hero
    attr_accessor :name, :gender, :eyecolor, :race, :haircolor, :height, :publisher, :skincolor, :alignment, :weight, :powers

    def initialize(data)
        data.each do |key, value|
            instance_variable_set("@#{key.downcase}", value) if respond_to?("#{key.downcase}=")
        end
    end

    def to_s
        return instance_variables.map { |var| "#{var} = #{instance_variable_get(var)}" }.join(',')
    end

end

def sample heroes
    # how many heroes have the power AcceleratedHealing?
    puts heroes.filter { |hero| hero.powers.include?("AcceleratedHealing") }.count

    # how many heroes have zero powers?
    puts heroes.filter { |hero| hero.powers.size == 0 }.count
end

def main
    # read each row of heroes_information.csv
    heroes = Array.new
    JSON.parse(File.read("heroes.json")).each do |row|
        heroes << Hero.new(row)
    end

    # run the sample code
    sample heroes    
end

if __FILE__ == $0
  main
end