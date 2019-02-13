require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

task :default => :spec

RSpec::Core::RakeTask.new(:test, :test_type) do |t, args|
  test_type = args[:test_type]
  directors = Dir.glob('spec/*').
    select { |f| File.directory? f }.
    map { |f| f.split("/")[1] }

  if directors.include?(test_type)
    t.pattern = Dir.glob("spec/#{test_type}/**/*_spec.rb")
  else
    puts "The argument must be one of the follow: #{directors}"
    return
  end
end
