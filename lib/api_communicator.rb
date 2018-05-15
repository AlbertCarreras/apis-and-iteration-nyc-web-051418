require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(search_value)
  character_array = get_info_from_api(search_value)

  films_array = character_array.find do |character_data|
    character_data["name"].downcase == search_value["name"]
  end

  if films_array == nil
    return puts "error, broke!"
  end

  films = films_array["films"]
end

def get_film_array_from_api(films)
  films.map do |film_hash|
    all_film_data = RestClient.get(film_hash)
    JSON.parse(all_film_data)
  end
end

def get_info_from_api(search_value)
  all_characters = RestClient.get("http://www.swapi.co/api/#{search_value["search_type"]}/")

  results = JSON.parse(all_characters)["results"]

  page = 1
  until JSON.parse(all_characters)["next"] == nil
      all_characters = RestClient.get("http://www.swapi.co/api/#{search_value["search_type"]}/?page=#{page}")
      JSON.parse(all_characters)["results"].each do |result|
        results << result
      end
      page += 1
  end

    results

end

def parse_character_movies(films_hash)
  films_hash.each do |movie_data_package|
    puts movie_data_package["title"]
  end
end

def show_character_movies(search_value)
  films_hash = get_character_movies_from_api(search_value)
  if films_hash == nil
    return puts "The character could not be found!"
  end
  films_hash = get_film_array_from_api(films_hash)
  parse_character_movies(films_hash)
end
