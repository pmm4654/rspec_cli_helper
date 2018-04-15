# method_finder.rb
require 'parser'
require 'parser/current'

module RspecCliHelper

  # HOW TO USE:

  # CASE: list all methods
  # method_finder = MethodFinder.new("app/models/your_file.rb")
  # puts method_finder.list_methods

  # CASE: find a specific method
  # method_finder = MethodFinder.new("app/models/your_file.rb")
  # puts method_finder.find("current_account")


  class MethodFinder
    attr_accessor :ast, :found_methods
    def initialize(filename)
      @ast = parse(filename)
      @found_methods = []
    end

    def find(method_name)
      recursive_search_ast(@ast, method_name)
      return @method_source
    end

    def list_methods
      return @found_methods unless @found_methods.empty?
      self.get_method_names(self.ast) # sets the found_methods array
      self.found_methods - Object.methods # returns all methods minus the object methods
    end

    def get_method_names(ast)
      ast.children.each do |child|
        if child.class.to_s == "Parser::AST::Node"
          if (child.type.to_s == "def" or child.type.to_s == "defs") #and (child.children[0].to_s == method_name or child.children[1].to_s == method_name)
            @found_methods << child.children[0]
            # @found_methods << child.loc.expression.source
          else
            get_method_names(child)
          end
        end
      end
    end

    private
    def parse(filename)
      Parser::CurrentRuby.parse(File.open(filename, "r").read)
    end

    def recursive_search_ast(ast, method_name)
      ast.children.each do |child|
        if child.class.to_s == "Parser::AST::Node"
          if (child.type.to_s == "def" or child.type.to_s == "defs") and (child.children[0].to_s == method_name or child.children[1].to_s == method_name)
            @method_source = child.loc.expression.source
          else
            recursive_search_ast(child, method_name)
          end
        end
      end
    end
  end

end