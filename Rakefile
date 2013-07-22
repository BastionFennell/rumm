require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "build the list of names and pack it into a pstore"
task "names:build" do
  require "pstore"
  adjective_file = File.expand_path "../app/providers/naming/adj.txt", __FILE__
  noun_file = File.expand_path "../app/providers/naming/nouns.txt", __FILE__
  PStore.new(File.expand_path("../app/providers/naming/dictionary.pstore", __FILE__)).tap do |store|
    store.transaction do
      adjectives = store["adjectives"] = {}
      File.open(adjective_file) do |file|
        file.each_line do |line|
          first_letter = line[0]
          adjectives[first_letter] ||= []
          adjectives[first_letter] << line.chomp
        end
      end
      nouns = store["nouns"] = {}
      File.open(noun_file) do |file|
        file.each_line do |line|
          first_letter = line[0]
          nouns[first_letter] ||= []
          nouns[first_letter] << line.chomp
        end
      end
    end
  end
end
