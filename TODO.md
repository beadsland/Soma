TODO
====

Table of Contents
-----------------

<!-- MDTOC maxdepth:6 firsth1:1 numbering:0 flatten:0 bullets:1 updateOnSave:1 -->

-	[TODO](#todo)  

	-	[Table of Contents](#table-of-contents)  
	-	[Utilities](#utilities)  
	-	[Literals](#literals)  

		-	[basic term framework](#basic-term-framework)  
		-	[fully flesh out integer](#fully-flesh-out-integer)  
		-	[fully flesh out numbers](#fully-flesh-out-numbers)  
		-	[basic elixir types](#basic-elixir-types)  
		-	[stringy stuff](#stringy-stuff)  
	-	[Complex Stuff](#complex-stuff)  

		-	[other data structures](#other-data-structures)  
		-	[matching semantics](#matching-semantics)  
		-	[other semantics](#other-semantics)  
		-	[distributed features](#distributed-features)  

<!-- /MDTOC -->

Utilities
---------

-	doc util scripts
-	manify util scripts
-	todoif myps1 tasks
-	myps1 project
-	todoify github issues

Literals
--------

### basic term framework

-	does generic tostring/tonumber work?
-	polymorphic perversion: to* outside protocol for type
-	recast coerce as proto, equiv as compare
-	replace html with md in term() doc
-	tolua method
-	readonly term table
-	readonly term metatable
-	integer cast
-	term cast of integer
-	doc integer

### fully flesh out integer

-	unit testing
-	concat meta for terms (error re term, not table)
-	generic bad operator error
-	math ops (+ - * / div rem)
-	other math ops? (exponation [pow?], etc)
-	length operator (#)
-	elixir-style length() and size()
-	elixir-style inspect()
-	equiv ops

### fully flesh out numbers

-	elixir integer methods library
-	float/number
-	strong equality (===)

### basic elixir types

-	atoms
-	truthy (nil / undef)
-	boolean operators

### stringy stuff

-	strings
-	elixir concat operator <>
-	regex
-	char lists
-	binaries
-	bitstrings
-	word list sigil

Complex Stuff
-------------

###enumerables

-	enumerable protocol
-	streams
-	cloning tables
-	lists (cast from array -> tail as stream of clone)
-	optional/default cap for tolua of (infinite) streams
-	lists should know they're finite, so waive cap
-	list operators (++ and --)
-	pipe operator (overload infix / -> returns stream or enum)
-	ranges

### other data structures

-	tuples
-	maps
-	structs

### matching semantics

-	matching
-	matching maps (must specify which keys to match on)
-	Soma variables
-	pin / unpin, bind methods
-	Soma scope (set of variables)
-	functions
-	control structures: case and cond

### other semantics

-	pure lua alternative to lbc
-	set up under corona
-	precompiler for DRY **DATA** section autogens
-	pure lua scheduler (& pids)
-	debug-dependent scheduler
-	messages / mailboxes
-	process links
-	try, catch and rescue

### distributed features

-	IO
-	nodes
-	messages with EVM
-	messages over HTML4 channel
-	android
-	Malt dual-platform dev
