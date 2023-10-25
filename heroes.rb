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

##### Part A #####
### 1. What are the most popular and least popular superpowers for superheroes with at least 1 superpower?
def get_popular_superpowers(heroes)
    superpowers_map = Hash.new(0)

    heroes.each do |hero|
        hero.powers.each do |power|
            superpowers_map[power] += 1
        end
    end

    # sort superpowers of popularity in descending order 
    sorted_superpowers = superpowers_map.sort_by { |power, count| -count }

    puts "Most popular superpowers: #{sorted_superpowers[0].first}"
    puts "Least popular superpowers: #{sorted_superpowers[-1].first}"
end

### 2. What is the average number of superpowers per superhero?
def get_average_superpowers(heroes)
    total_superpowers = heroes.sum { |hero| hero.powers.length }
    average_superpowers = total_superpowers.to_f / heroes.length

    puts "Average number of superpowers per superhero: #{average_superpowers}"
end

### 3. What is the average number of superpowers for superheroes with at least 1 superpower?
def get_average_superpowers_new(heroes)
    heroes_with_superpowers = heroes.select { |hero| hero.powers.any? } 
    total_superpowers = heroes_with_superpowers.sum { |hero| hero.powers.length }
    average_superpowers = total_superpowers.to_f / heroes_with_superpowers.length

    puts "Average number of superpowers for superheroes with at least 1 superpower: #{average_superpowers}"
end

### 4. What are the most popular and least popular superpowers by publisher?
def get_popular_superpowers_publisher(heroes)
    # Create a hash that has publishers as keys and a nested hash as a value
    # The nested hash stores superpowers as keys and their counts as values
    publisher_superpowers_map = Hash.new { |hash, key| hash[key] = Hash.new(0) }

    heroes.each do |hero|
        hero.powers.each do |power|
            if hero.publisher
                publisher_superpowers_map[hero.publisher.strip][power] += 1
            end
        end
    end

    publisher_superpowers_map.each do |publisher, superpowers|
        most_popular_superpower = superpowers.max_by { |power, count| count }
        least_popular_superpower = superpowers.min_by { |power, count| count }

        puts "#{publisher}: Most popular: #{most_popular_superpower[0]}; Least popular: #{least_popular_superpower[0]}"
    end
end

### 5. What is the breakdown by gender of the superheroes?
def get_breakdown_gender(heroes)
    gender_map = Hash.new(0)

    heroes.each do |hero|
        gender = hero.gender
        gender = "unknown" if gender.nil?
        gender_map[gender] += 1 
    end

    gender_map.each do |gender, count|
        gender = "unknown" if gender.nil?
        puts "#{gender.capitalize}: #{count}"
    end
end

##### Part B #####
### 1. What is the average height of superheros?
def get_average_height(heroes)
    total_height = heroes.sum { |hero| hero.height.to_f }
    average = total_height / heroes.length
    puts "Average height of superheroes: #{average}"

    valid_heroes = heroes.select { |hero| hero.height.to_f > 0 }
    total_valid_height = valid_heroes.sum { |hero| hero.height.to_f }
    valid_average = total_valid_height / valid_heroes.length
    puts "Average height of valid superheroes: #{valid_average}"
end

### 5. What is the breakdown by race of the superheroes?
def get_breakdown_race(heroes)
    race_map = Hash.new(0)

    heroes.each do |hero|
        race = hero.race
        race = "unknown" if race.nil?
        race_map[race] += 1 
    end

    sorted_race_map = race_map.sort_by { |race, count| -count }

    sorted_race_map.each do |race, count|
        race = "unknown" if race.nil?
        puts "#{race}: #{count}"
    end
end

##### Part C #####
### List powers
def list_powers(heroes)
    powers = heroes.map { |hero| hero.powers }.flatten.compact.uniq
    powers.each { |power| puts power }
end

### Find heroes with the most powers 
def get_strongest_superheroes(heroes)
    max = heroes.max_by { |hero| hero.powers.length }.powers.length
    strongest_heroes = heroes.select { |hero| hero.powers.length == max }
    puts "#{max} powers"
    strongest_heroes.each do |hero|
        puts "#{hero.name}"
    end
end

### Find heroes with the least powers 
def get_weakest_superheroes(heroes)
    min = heroes.min_by { |hero| hero.powers.length }.powers.length
    weakest_heroes = heroes.select { |hero| hero.powers.length == min }
    puts "#{min} powers"
    weakest_heroes.each do |hero|
        puts "#{hero.name}"
    end
end

### Search heroes
def search_superhero(heroes, name)
    found_heroes = heroes.select { |hero| hero.name == name }
    
    if found_heroes.empty?
        puts "No hero with the name '#{name}' found."
    else
        found_heroes.each do |hero|
            puts "Name: #{hero.name}"
            puts "Gender: #{hero.gender}"
            puts "Eye Color: #{hero.eyecolor}"
            puts "Race: #{hero.race}"
            puts "Hair Color: #{hero.haircolor}"
            puts "Height: #{hero.height}"
            puts "Publisher: #{hero.publisher}"
            puts "Skin Color: #{hero.skincolor}"
            puts "Alignment: #{hero.alignment}"
            puts "Weight: #{hero.weight}"
            puts "Powers: #{hero.powers.join(', ')}"
        end
    end
end


def main
    # read each row of heroes_information.csv
    heroes = Array.new
    #JSON.parse(File.read("heroes.json")).each do |row|
    JSON.parse(File.read("newHeroes.json")).each do |row|
        heroes << Hero.new(row)
    end

    # run the sample code
    sample heroes 
    get_popular_superpowers(heroes)
    get_average_superpowers(heroes)
    get_average_superpowers_new(heroes)
    get_popular_superpowers_publisher(heroes)
    get_breakdown_gender(heroes)
    get_average_height(heroes)
    get_breakdown_race(heroes)
    list_powers(heroes)
    get_strongest_superheroes(heroes)
    get_weakest_superheroes(heroes)

    heroes = JSON.parse(File.read("newHeroes.json")).map { |row| Hero.new(row) }
    print "Enter a hero's name: "
    hero_name = gets.chomp
    search_superhero(heroes, hero_name)
end

if __FILE__ == $0
  main
end