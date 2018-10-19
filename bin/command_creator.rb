verb, subject, file_name = ARGV

def format_file_name(name)
  new_word = ""

  counter = 0
  name.each_char do |letter|
    if letter == letter.upcase && counter != 0
      new_word << "_"
    end
    new_word << letter
    counter += 1
  end

  new_word.downcase
end

def create_folder(path)
  unless File.exists?(path)
    Dir.mkdir(folder_name)
    puts "#{folder_name} created"
  end
end

if verb == 'new' && subject == 'command'
  path = "lib/commands"
  create_folder(path)
  file_path_name = path + "/" + format_file_name(file_name) + ".rb"

  if File.file?(file_path_name)
    puts "#{file_path_name} already exist"
    return
  end

  puts "#{file_path_name} created"
  file = File.new(file_path_name, "w+")

  file << "module Commands\n"
  file << "  class #{file_name}\n"
  file << "    def applies_to?(request)\n"
  file << "    end\n\n"
  file << "    def prepare(data)\n"
  file << "    end\n\n"
  file << "    def run\n"
  file << "    end\n"
  file << "  end\n"
  file << "end"

  path = "spec/commands"
  create_folder(path)
  file_path_name_spec = path + "/" + format_file_name(file_name + "Spec") + ".rb"
  puts "#{file_path_name} created"
  file = File.new(file_path_name_spec, "w+")

  file << "require 'commands/#{format_file_name(file_name)}'\n\n"
  file << "RSpec.describe Commands::#{file_name} do\n"
  file << "  it \"should implement a test\" do\n"
  file << "    expect(true).to eq(false)\n"
  file << "  end\n"
  file << "end"
end
