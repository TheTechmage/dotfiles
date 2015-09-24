#!/usr/bin/env ruby
## Requires treetop
# gem install treetop
require 'treetop'
require 'stringio'


# http://thingsaaronmade.com/blog/a-quick-intro-to-writing-a-parser-using-treetop.html
module Conky
	class VariableLiteral < Treetop::Runtime::SyntaxNode
	end
	class StringLiteral < Treetop::Runtime::SyntaxNode
	end
	class Body < Treetop::Runtime::SyntaxNode
	end
	class Exp < Treetop::Runtime::SyntaxNode
	end
end
WrapWidth = 40

TestString = <<EOF
grammar Conky
	rule expression
		(body space)+
		{
			def content
				elements.map{|e| [e.body.content, e.space.text_value] }
			end
		}
	end
	rule body
		(variable / string)+ <Body>
		{
			def content
				elements.map do |e|
					elem = e.content
					if elem[0] == :string then
						s = elem[1]
						[elem[0], s.gsub(/(.{1,#{WrapWidth}})(\\s+|\\Z)/, "\\\\1\\n").strip]
					else
						elem
					end
				end
			end
		}
	end
	rule variable
		'${' string '}' <VariableLiteral>
		{
			def content
				[:var, text_value]
			end
		}
	end
	rule string
		[a-zA-Z0-9_\=\#\(\)\@\+\'\" ]+ <StringLiteral>
		{
			def content
				[:string, text_value]
			end
		}
	end
	rule space
		[\\n\\r]
	end
end
EOF

class Parser
	Treetop.load_from_string(TestString)
	@@parser = ConkyParser.new

	def self.parse(data)
		tree = @@parser.parse(data)
		if(tree.nil?)
			puts @@parser.failure_reason
			raise Exception, "Parse error at offset: #{@@parser.index}\n#{@@parser.failure_reason}"
		end
		self.clean_tree tree
		return tree
	end

	private
	def self.clean_tree(root_node)
		return if(root_node.elements.nil?)
		#root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
		root_node.elements.each {|node| self.clean_tree(node) }
	end
end

todo=`todo.sh -d ~/.conky/todo-conky ls | head --lines=-2` # | fold -w68
#todo.gsub! '}', ' } '
#puts todo
#todo = StringIO.new todo
#puts Parser.parse(todo).inspect
parsed=Parser.parse(todo).content
#puts parsed.inspect
parsed.each do |e|
	e[0].each do |node|
		#puts node.inspect
		#next
		print node[1]
		#if node[0] == :string then
		#	puts node[1].inspect
		#end
	end
	print e[1]
	$stdout.flush
end

# http://caiustheory.com/why-i-love-data/
__END__
