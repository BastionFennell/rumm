require "pstore"

class NamingProvider

  def value
    self
  end

  def generate_name(adj_first_letter = nil, noun_first_letter = nil)
    "#{adjective adj_first_letter}-#{noun noun_first_letter}"
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
    first_letter ||= random_letter
    list = dictionary('nouns')[first_letter]
    list[rand(list.length - 1)]
  end

  def adjective(first_letter)
    first_letter ||= random_letter
    list = dictionary('adjectives')[first_letter]
    list[rand(list.length - 1)]
  end
end
