class NamingProvider

  def value
    self
  end

  def generate_name adj, noun
    if adj == nil and noun == nil
      get_adj + "-" + get_noun
    else
      get_adj_bound(adj) + "-" + get_noun_bound(noun)
    end
  end

  private

  def get_adj
    a = rand(20748)
    counter = 0
    dict = File.new(File.expand_path "../naming/adj.txt", __FILE__)
    dict.each_line do |line|
      if counter == a
        return line.delete("\n")
      end
      counter+=1
    end
  end

  def get_noun
    a = rand(55875)
    counter = 0
    dict = File.new(File.expand_path "../naming/nouns.txt", __FILE__)
    dict.each_line do |line|
      if counter == a
        return line.delete("\n")
      end
      counter+=1
    end
  end

  def get_adj_bound letter
    higher = true
    upper = 20748
    lower = 0
    a = 0
    word = ""
    done = false
    until done
      if higher
        lower = a
      else
        upper = a
      end
      a = rand lower..upper
      counter = 0
      dict = File.new(File.expand_path "../naming/adj.txt", __FILE__)
      dict.each_line do |line|
        if counter == a
          word = line.delete("\n")
          break
        end
        counter+=1
      end
      if word[0] == letter
        return word
      elsif word[0] <= letter
        higher = true
      else
        higher = false
      end
    end
  end

  def get_noun_bound letter
    higher = true
    upper = 55875
    lower = 0
    a = 0
    word = ""
    done = false
    until done
      if higher
        lower = a
      else
        upper = a
      end
      a = rand lower..upper
      counter = 0
      dict = File.new(File.expand_path "../naming/nouns.txt", __FILE__)
      dict.each_line do |line|
        if counter == a
          word = line.delete("\n")
          break
        end
        counter+=1
      end
      if word[0] == letter
        return word
      elsif word[0] <= letter
        higher = true
      else
        higher = false
      end
    end
  end
end
