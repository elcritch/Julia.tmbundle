

testerr = """
ERROR: syntax: extra token "ValueError" after end of expression
 in include at /Applications/Julia-0.3.5.app/Contents/Resources/julia/lib/julia/sys.dylib
 in include_from_node1 at loading.jl:128
 in process_options at /Applications/Julia-0.3.5.app/Contents/Resources/julia/lib/julia/sys.dylib
 in _start at /Applications/Julia-0.3.5.app/Contents/Resources/julia/lib/julia/sys.dylib
while loading /Users/elcritch/proj/code/tabulate.jl/tabulate.jl, in expression starting on line 211
"""

# println(repr(testerr))

using PEGParser

@grammar julia_error begin
	start = r"ERROR:" + Error

	Error = kind + message + Tracebacks
		kind = -space + r"\w+" + ":"
		message = r".+"
	Tracebacks = +( TraceBack ) + TraceEnd
	
	TraceBack = -space + "in" + methodname + " at" + fileurl
		fileurl = filepath + ?( ":" + linenumber) + endl
		methodname = -space + r"[\w!_]+"
	TraceEnd = "while loading" + filepathend + " in expression starting on " + ("line " + linenumber)

	linenumber = + r"\d+"
	filepath = -space + r".+"
	filepathend = -space + r".+,"
	
    space = r"[ \t\n\r]*"
	endl = r"[\n\r]"
end



println("="^40)

function parse(grammar::Grammar, text::String)
  rule = grammar.rules[:start]
  cache = StandardCache(Dict{String, Node}())
  
  (ast, pos, error) = PEGParser.parse(grammar, rule, text, 1, cache)

  # if pos < length(text) + 1
  #   error = ParseError("Entire string did not match", pos)
  # end

  return (ast, pos, error, cache)
end



# (ast, pos, error) = parse(grammar, rule, text, 1, cache, Dict{String, Node}())


(ast, pos, error, cache) = parse(julia_error, testerr)
println(ast)
println("\n", "="^40, "Error","\n")

println(error)

println("\n", "="^40, "Cache","\n")

println(cache)




