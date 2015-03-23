

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
	start = r"ERROR:" + error

	error = errorkind + errormessage + tracebacks
	errorkind = -space + r"\w+" + ":"
	errormessage = r".+"
	tracebacks = +( traceback ) + traceend
	
	traceback = -space + "in" + methodname + " at" + fileurl
	fileurl = filepath + ?( ":" + linenumber) + endl
	methodname = -space + r"[\w!_]+"
	traceend = "while loading" + filepathend + " in expression starting on " + ("line " + linenumber)

	linenumber = + r"\d+"
	filepath = -space + r".+"
	filepathend = -space + r".+,"
	
    space = r"[ \t\n\r]*"
	endl = r"[\n\r]"
end

println("="^40)

(ast, pos, error) = parse(julia_error, testerr)
println(ast)


# function parse(grammar::Grammar, text::String; cache=true, start=:start)
#   rule = grammar.rules[start]
#
#   (ast, pos, error) = parse(grammar, rule, text, 1, cache, Dict{String, Node}())
#
#   if pos < length(text) + 1
#     error = ParseError("Entire string did not match", pos)
#   end
#
#   return (ast, pos, error);
# end
#

# @grammar calc1 begin
#   start = (number + op + number) { apply(eval(_2), _1, _3) }
#
#   op = plus | minus
#   number = (-space + r"[0-9]+") {parseint(_1.value)}
#   plus = (-space + "+") {symbol(_1.value)}
#   minus = (-space + "-") {symbol(_1.value)}
#   space = r"[ \t\n\r]*"
# end
#
#
# println("="^40)
#
# data = "4+5"
# (ast, pos, error) = parse(calc1, data)
# println(ast)


