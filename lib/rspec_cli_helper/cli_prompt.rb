require 'tty-prompt'
require "rspec_cli_helper/method_finder"
require 'byebug'


module RspecCliHelper

  module CliPrompt

    def collect_types_of(file_type)
      files_of_type = []
      Dir.foreach("app/#{file_type}") do |filename|
         files_of_type << filename
      end
      files_of_type
    end

    def start_prompt
      prompt = TTY::Prompt.new

      spec_choices    = {model: "models", request: "requests", feature: "features"}
      spec_type       = prompt.select("What type of spec do you want?", spec_choices)
      file_to_spec    = prompt.select("What #{spec_type} do you want to create a spec for?", collect_types_of(spec_type), filter: true)

      method_finder   = MethodFinder.new("app/#{spec_type}/#{file_to_spec}")
      method_list = method_finder.list_methods
      method_list.map!(&:to_s)


      methods_to_spec = prompt.multi_select("What method do you want to test?", method_list, filter: true)


      results = prompt.collect do
        methods_to_spec.each do |method|
          puts "\n#{method_finder.find(method)}\n"
          key("#{method}").values do
            key(:context).ask("Enter a context description for the test")
            key(:setup).multiline("Enter any setup your tests need.") 
            key(:expectation).ask('What should you expect when calling this method?', required: true)
          end
        end
      end

      File.open("sample_test_spec.rb", "a+") do |f|
        results.each do |method_name, array_expectations|
          f.puts "describe \"#{method_name}\" do"
          f.puts "  context \"#{array_expectations.first[:context]}\" do"
          f.puts "    it \"should return #{array_expectations.first[:expectation]}\" do"
          array_expectations.first[:setup].each do |setup_step|
            f.puts "      #{setup_step}"
          end
          f.puts ""
          f.puts "      expect(#{file_to_spec.gsub(".rb", "")}.#{method_name}).to eq(#{array_expectations.first[:expectation]})"
          f.puts "    end"
          f.puts "  end"
          f.puts "end"
          f.puts "\n"
        end  
      end

      results.each do |method_name, array_expectations|
        puts "describe \"#{method_name}\" do"
        puts "  context \"#{array_expectations.first[:context]}\" do"
        puts "    it \"should return #{array_expectations.first[:expectation]}\" do"
        array_expectations.first[:setup].each do |setup_step|
          puts "      #{setup_step}"
        end
        puts ""
        puts "      expect(#{file_to_spec.gsub(".rb", "")}.#{method_name}).to eq(#{array_expectations.first[:expectation]})"
        puts "    end"
        puts "  end"
        puts "end"
        puts "\n"
      end

      puts results
    end

  end

end