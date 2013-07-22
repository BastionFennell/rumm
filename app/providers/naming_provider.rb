require "pstore"

class NamingProvider

  def value
    self
  end

  def generate_name(first_letter = random_letter, last_letter = random_letter)
    "#{adjective first_letter}-#{noun last_letter}"
  end

  def random_letter
    ('a'..'z').to_a.shuffle.first
  end

  private

  def dictionary(key)
    @dictionary ||= PStore.new dictionary_file
    @dictionary.transaction(true) { @dictionary[key] }
  end

  def dictionary_file
    File.expand_path '../naming/dictionary.pstore', __FILE__
  end

  def noun(first_letter)
    list = dictionary('nouns')[first_letter]
    list[rand(list.length - 1)]
  end

  def adjective(first_letter)
    list = dictionary('adjectives')[first_letter]
    list[rand(list.length - 1)]
  end
end
