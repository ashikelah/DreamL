%%
:- initialization main.

query :- current_prolog_flag(argv, Argv), concat_atom(Argv, ' ', Atom), read_term_from_atom(Atom, Term, []), call(Term), extract(Term).
main :- catch(query, E, (print_message(error, E), fail)), halt.
main :- halt(1).

extract(dream_program(Tree,_,_)) :- writeln(Tree).
extract(eval_dream_program(_,_,_)).
%%

:- discontiguous eval_command/3, command/3.
:- table boolean/3, eval_arithmetic/3.

%% intializing program with block
%% a program ends with a semicolon
dream_program(X)			--> block(X).

%% body contains declarations followed by commands.
%% block can be of two kind start/end block OR a function declaration that returns a single value.
block(startstop(X))			--> [start], body(X), [';'], [stop].
block(function(X;Y))			--> [function], ['('], [')'], [start], body(X), [';'], [return],  value(Y), [';'], [stop].
block(function(X;Y;Z))			--> [function], ['('], comma_declaration(X), [')'], [start], body(Y), [';'], [return], value(Z), [';'], [stop].

%% body contains declarations followed by commands.
body(body(X))				--> command(X).
body(body(X;Y))				--> command(X), [';'], body(Y).

body(body(X))				--> body_declaration(X).
body(body(X;Y))				--> body_declaration(X), [';'], body(Y).

%% DReaM supports 3 kinds of datatypes, string, number, and boolean
%% declaration can be separated by commas OR semicolons
comma_declaration(comma_declare(X))	--> declaration(X).
comma_declaration(comma_declare(X;Y))	--> declaration(X), [','], comma_declaration(Y).

semicolon_declaration(semicolon_declare(X))	--> declaration(X).
semicolon_declaration(semicolon_declare(X;Y))	--> declaration(X), [';'], semicolon_declaration(Y).

body_declaration(body_declare(X))	--> declaration(X).
body_declaration(body_declare(X;Y))	--> declaration(X), [';'], body_declaration(Y).

body_declaration(body_declare(X))	--> comma_declaration(X).
body_declaration(body_declare(X;Y))	--> comma_declaration(X), [';'], body_declaration(Y).

body_declaration(body_declare(X))	--> semicolon_declaration(X).
body_declaration(body_declare(X;Y))	--> semicolon_declaration(X), [';'], body_declaration(Y).

%%
declaration(string(X))			--> variable(X), [string].
declaration(number(X))			--> variable(X), [number].
declaration(boolean(X))			--> variable(X), [boolean].

%% COMMANDS
%% Assignment
command(X:=Y)				--> variable(X), ['='], concat(Y).
command(X:=Y;Z)				--> variable(X), ['='], concat(Y), [;], body(Z).

command(X:=Y)				--> variable(X), ['='], string(Y).
command(X:=Y;Z)				--> variable(X), ['='], string(Y), [;], body(Z).

command(X:=Y)				--> variable(X), ['='], arithmetic(Y).
command(X:=Y;Z)				--> variable(X), ['='], arithmetic(Y), [;], body(Z).

command(X:=Y)				--> variable(X), ['='], boolean(Y).
command(X:=Y;Z)				--> variable(X), ['='], boolean(Y), [;], body(Z).

%% write output
command(print_std(X))			--> [print], value(X).
command(print_std(X);Y)			--> [print], value(X), [';'], body(Y).

command(println_std(X))			--> [println], value(X).
command(println_std(X);Y)		--> [println], value(X), [';'], body(Y).

%% Loops
%% The For Loop
command(for(X;Y;Z;do(U)))		--> [for], ['('], variable(X), [';'], boolean(Y), [';'], arithmetic(Z), [')'], [start], body(U), [';'], [stop].
command(for(X;Y;Z;do(U);V))		--> [for], ['('], variable(X), [';'], boolean(Y), [';'], arithmetic(Z), [')'], [start], body(U), [';'], [stop], [';'], body(V).

command(for(X;Y;Z;do(U)))		--> [for], ['('], variable(X), [';'], boolean(Y), [';'], abatement(Z), [')'], [start], body(U), [';'], [stop].
command(for(X;Y;Z;do(U);V))		--> [for], ['('], variable(X), [';'], boolean(Y), [';'], abatement(Z), [')'], [start], body(U), [';'], [stop], [';'], body(V).

command(for(X;Y;Z;do(U)))		--> [for], ['('], variable(X), [';'], boolean(Y), [';'], increase(Z), [')'], [start], body(U), [';'], [stop].
command(for(X;Y;Z;do(U);V))		--> [for], ['('], variable(X), [';'], boolean(Y), [';'], increase(Z), [')'], [start], body(U), [';'], [stop], [';'], body(V).

%% The Condensed Loop
command(range(X;Y;Z;do(U)))		--> [for], variable(X), [in], [range], ['('], number(Y), ['.'], ['.'], number(Z), [')'], [start], body(U), [';'], [stop].
command(range(X;Y;Z;do(U);V))		--> [for], variable(X), [in], [range], ['('], number(Y), ['.'], ['.'], number(Z), [')'], [start], body(U), [';'], [stop], [';'], body(V).

%% The While Loop	
command(while(X;do(Y))) 		--> [while], ['('], boolean(X), [')'], [start], body(Y), [';'], [stop].
command(while(X;do(Y);Z)) 		--> [while], ['('], boolean(X), [')'], [start], body(Y), [';'], [stop], [';'], body(Z).

%% Conditional Statements
%% The If-Else Condition
command(if(X;then(Y);else(Z)))		--> [if], ['('], boolean(X), [')'], [start], body(Y), [';'], [stop], [';'], [else], [start], body(Z), [';'], [stop].
command(if(X;then(Y);else(Z);U))	--> [if], ['('], boolean(X), [')'], [start], body(Y), [';'], [stop], [';'], [else], [start], body(Z), [';'], [stop], body(U).

%% the if condition
command(if(X;then(Y)))			--> [if], ['('], boolean(X), [')'], [start], body(Y), [';'], [stop].
command(if(X;then(Y);Z))		--> [if], ['('], boolean(X), [')'], [start], body(Y), [';'], [stop], [';'], body(Z).

%% The Ternary Condition
command(V:=X:Y;Z)			--> variable(V), ['='], boolean(X), ['?'], value(Y), [':'], value(Z).
command(V:=X:Y;Z;U)			--> variable(V), ['='], boolean(X), ['?'], value(Y), [':'], value(Z), [';'], body(U).

%% SYNTACTIC SUGARS
%% Increment
increase(inc(X))			--> variable(X), ['+'], ['+'].
increase(inc(X))			--> ['+'], ['+'], variable(X).
    
command(increment(X))			--> increase(X).
command(increment(X);Y)			--> increase(X), [';'], body(Y).

%% abatement
abatement(dec(X))			--> variable(X), ['-'], ['-'].
abatement(dec(X))			--> ['-'], ['-'], variable(X).

command(decrement(X))			--> abatement(X).
command(decrement(X);Y)			--> abatement(X), [';'], body(Y).

%% Short Assignment
command(short_add(X;Y))			--> variable(X), ['+'], ['='], value(Y).
command(short_add(X;Y);Z)		--> variable(X), ['+'], ['='], value(Y), [';'], body(Z).

command(short_min(X;Y))			--> variable(X), ['-'], ['='], value(Y).
command(short_min(X;Y);Z)		--> variable(X), ['-'], ['='], value(Y), [';'], body(Z).

command(short_mul(X;Y))			--> variable(X), ['*'], ['='], value(Y).
command(short_mul(X;Y);Z)		--> variable(X), ['*'], ['='], value(Y), [';'], body(Z).

command(short_div(X;Y))			--> variable(X), ['/'], ['='], value(Y).
command(short_div(X;Y);Z)		--> variable(X), ['/'], ['='], value(Y), [';'], body(Z).

%% OPERATIONS
%% Datatypes Literals
value(X)				--> string(X) | number(X) | variable(X).

%% String Operations
concat(join(X;Y))			--> value(X), ['#'], value(Y).
concat(join(X;Y))			--> value(X), ['#'], concat(Y).

%% Arithmetic Operations
arithmetic(X:=Y)			--> variable(X), ['='], arithmetic(Y).
arithmetic(X:=Y;Z)			--> variable(X), ['='], arithmetic(Y), [;], body(Z).

arithmetic(X)				--> number(X) | variable(X).
arithmetic((X))				--> ['('], arithmetic(X), [')'].

arithmetic(X:Y)				--> term(X), ['@'], arithmetic(Y).
arithmetic(X+Y)				--> term(X), ['+'], arithmetic(Y).
arithmetic(X-Y)				--> term(X), ['-'], arithmetic(Y).
arithmetic(X) 				--> term(X).

term(X/Y)				--> literals(X), ['/'], term(Y).
term(X*Y) 				--> literals(X), ['*'], term(Y).
term((X))				--> ['('], arithmetic(X), [')'].
term(X)	 				--> literals(X).

literals((X))				--> ['('], arithmetic(X), [')'].
literals(X)				--> number(X) | variable(X).

%% Relational Operators/Operations
bool(true)				--> [true].
bool(true)				--> [false].
bool(X)					--> variable(X).

boolean(X) 				--> bool(X).
boolean(X==Y) 				--> arithmetic(X), ['='], ['='], arithmetic(Y).
boolean(X>Y) 				--> arithmetic(X), ['>'], arithmetic(Y).
boolean(X>>Y) 				--> arithmetic(X), ['>'], ['='], arithmetic(Y).
boolean(X<Y) 				--> arithmetic(X), ['<'], arithmetic(Y).
boolean(X<<Y) 				--> arithmetic(X), ['='], ['<'], arithmetic(Y).
boolean(X//Y)				--> arithmetic(X), ['!'], ['='], arithmetic(Y).

boolean(not(X)) 			--> ['!'], boolean(X).
boolean(and(X;Y)) 			--> boolean(X), ['&&'], boolean(Y).
boolean(or(X;Y)) 			--> boolean(X), ['||'], boolean(Y).
boolean(xor(X;Y)) 			--> boolean(X), ['^'], boolean(Y).

%% String Literal
string({X})				--> ['{'], string(X), ['}'].
string(X)				--> [X].

%% numbers
number(X)				--> [X], {number(X)}.
number(signed(X))			--> ['-'], number(X).

%% variables
variable(X)				--> [X], {\+ number(X)}, {atomic(X)},{string_chars(X,C), chars(C)}.
chars([]).
chars([H|T]) 				:- char(H), chars(T).  
char(a).
char(b).
char(c).
char(d).
char(e).
char(f).
char(g).
char(h).
char(i).
char(j).
char(k).
char(l).
char(m).
char(n).
char(o).
char(p).
char(q).
char(r).
char(s).
char(t).
char(u).
char(v).
char(w).
char(x).
char(y).
char(z).

%% -----------------------------------------------------------------------------------
%% EVALUATION STATEMENTS
%% -----------------------------------------------------------------------------------
%% Program evaluation
eval_dream_program(Tree, [], Output) 				:- eval_block(Tree, [], Output), nl, write(Output).

eval_block(startstop(X), Env, Result) 				:- eval_body(X, Env, Result).
eval_block(function(X;Y), Env, Result) 				:- eval_body(X, Env, Temp), eval_value(Y, Temp, [(Result, _)]).
eval_block(function(X;Y;Z), Env, Result) 			:- eval_comma_declaration(X, Env, Temp), eval_body(Y, Temp, Temp2), eval_value(Z, Temp2, [(Result, _)]).

eval_body(body(X), Env, Result) 				:- eval_command(X, Env, Result).
eval_body(body(X;Y), Env, Result) 				:- eval_command(X, Env, Temp), eval_body(Y, Temp, Result).

eval_body(body(X), Env, Result) 				:- eval_body_declaration(X, Env, Result).
eval_body(body(X;Y), Env, Result) 				:- eval_body_declaration(X, Env, Temp), eval_body(Y, Temp, Result).

%%
eval_comma_declaration(comma_declare(X), Env, Result) 		:- eval_declaration(X, Env, Result).
eval_comma_declaration(comma_declare(X;Y), Env, Result) 	:- eval_declaration(X, Env, Temp), eval_comma_declaration(Y, Temp, Result).

eval_semicolon_declaration(semicolon_declare(X), Env, Result) 	:- eval_declaration(X, Env, Result).
eval_semicolon_declaration(semicolon_declare(X;Y), Env, Result) :- eval_declaration(X, Env, Temp), eval_semicolon_declaration(Y, Temp, Result).

eval_body_declaration(body_declare(X), Env, Result) 	:- eval_declaration(X, Env, Result).
eval_body_declaration(body_declare(X;Y), Env, Result) 	:- eval_declaration(X, Env, Temp), eval_body_declaration(Y, Temp, Result).

eval_body_declaration(body_declare(X), Env, Result) 	:- eval_semicolon_declaration(X, Env, Result).
eval_body_declaration(body_declare(X;Y), Env, Result) 	:- eval_semicolon_declaration(X, Env, Temp), eval_body_declaration(Y, Temp, Result).

eval_body_declaration(body_declare(X), Env, Result) 	:- eval_comma_declaration(X, Env, Result).
eval_body_declaration(body_declare(X;Y), Env, Result) 	:- eval_comma_declaration(X, Env, Temp), eval_body_declaration(Y, Temp, Result).

%%
eval_declaration(string(X), Env, Result) 		:- add_variable(X, " ", string, Env, Result).
eval_declaration(number(X), Env, Result) 		:- add_variable(X, 0, number, Env, Result).
eval_declaration(boolean(X), Env, Result) 		:- add_variable(X, false, boolean, Env, Result).

%% Commands
%% string concat operation
eval_command(X:=Y, Env, Result) 			:- variable_lookup(X, Env, [(_, boolean)]), eval_boolean(Y, Env, Value), update_variable(X, Value, Env, Result).
eval_command(X:=Y;Z, Env, Result) 			:- variable_lookup(X, Env, [(_, boolean)]), eval_boolean(Y, Env, Value), update_variable(X, Value, Env, Temp), eval_body(Z, Temp, Result).

eval_command(X:=Y, Env, Result) 			:- variable_lookup(X, Env, [(_, number)]), eval_arithmetic(Y, Env, Value), update_variable(X, Value, Env, Result).
eval_command(X:=Y;Z, Env, Result) 			:- variable_lookup(X, Env, [(_, number)]), eval_arithmetic(Y, Env, Value), update_variable(X, Value, Env, Temp), eval_body(Z, Temp, Result).

eval_command(X:=Y, Env, Result) 			:- variable_lookup(X, Env, [(_, string)]), eval_concat(Y, Env, Value), update_variable(X, Value, Env, Result).
eval_command(X:=Y;Z, Env, Result) 			:- variable_lookup(X, Env, [(_, string)]), eval_concat(Y, Env, Value), update_variable(X, Value, Env, Temp), eval_body(Z, Temp, Result).

eval_command(X:=Y, Env, Result) 			:- variable_lookup(X, Env, [(_, string)]), eval_string(Y, _, Value), update_variable(X, Value, Env, Result).
eval_command(X:=Y;Z, Env, Result) 			:- variable_lookup(X, Env, [(_, string)]), eval_string(Y, _, Value), update_variable(X, Value, Env, Temp), eval_body(Z, Temp, Result).

%% write
eval_command(print_std(X), Env, Env) 			:- eval_value(X, Env, [(Value, _)]), write(Value).
eval_command(print_std(X);Y, Env, Result) 		:- eval_value(X, Env, [(Value, _)]), write(Value), eval_body(Y, Env, Result).

eval_command(println_std(X), Env, Env) 			:- eval_value(X, Env, [(Value, _)]), write(Value), nl.
eval_command(println_std(X);Y, Env, Result) 		:- eval_value(X, Env, [(Value, _)]), write(Value), nl, eval_body(Y, Env, Result).

%% LOOPS
%% the for loop
eval_command(for(X;Y;Z;do(U)), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, true), eval_body(U, Env, Temp), eval_increase(Z, Temp, Temp1), eval_command(for(X;Y;Z;do(U)), Temp1, Result).
eval_command(for(X;Y;_;do(_)), Env, Env) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, false).
eval_command(for(X;Y;Z;do(U);V), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, true), eval_body(U, Env, Temp), eval_increase(Z, Temp, Temp1), eval_command(for(X;Y;Z;do(U)), Temp1, Temp2), eval_body(V, Temp2, Result).
eval_command(for(X;Y;_;do(_);V), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, false), eval_body(V, Env, Result).
%
eval_command(for(X;Y;Z;do(U)), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, true), eval_body(U, Env, Temp), eval_abatement(Z, Temp, Temp1), eval_command(for(X;Y;Z;do(U)), Temp1, Result).
eval_command(for(X;Y;_;do(_)), Env, Env) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, false).
eval_command(for(X;Y;Z;do(U);V), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, true), eval_body(U, Env, Temp), eval_abatement(Z, Temp, Temp1), eval_command(for(X;Y;Z;do(U)), Temp1, Temp2), eval_body(V, Temp2, Result).
eval_command(for(X;Y;_;do(_);V), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, false), eval_body(V, Env, Result).
%
eval_command(for(X;Y;Z;do(U)), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, true), eval_body(U, Env, Temp), eval_arithmetic(Z, Temp, Temp1), eval_command(for(X;Y;Z;do(U)), Temp1, Result).
eval_command(for(X;Y;_;do(_)), Env, Env) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, false).
eval_command(for(X;Y;Z;do(U);V), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, true), eval_body(U, Env, Temp), eval_arithmetic(Z, Temp, Temp1), eval_command(for(X;Y;Z;do(U)), Temp1, Temp2), eval_body(V, Temp2, Result).
eval_command(for(X;Y;_;do(_);V), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_boolean(Y, Env, false), eval_body(V, Env, Result).

%% The Condensed Loop
eval_command(range(X;Y;Z;do(U)), Env, Result)		:- variable_lookup(X, Env, [(_, number)]), number_lookup(Y, _, Start), number_lookup(Z, _, End), Start =< End, update_variable(X, Start, Env, Temp), eval_body(U, Temp, Temp1), Value is Start + 1, eval_command(range(X;Value;Z;do(U)), Temp1, Result).
eval_command(range(X;Y;Z;do(_)), Env, Env)		:- variable_lookup(X, Env, [(_, number)]), number_lookup(Y, _, Start), number_lookup(Z, _, End), Start > End.
eval_command(range(X;Y;Z;do(U);V), Env, Result)		:- variable_lookup(X, Env, [(_, number)]), number_lookup(Y, _, Start), number_lookup(Z, _, End), Start =< End, update_variable(X, Start, Env, Temp), eval_body(U, Temp, Temp1), Value is Start + 1, eval_command(range(X;Value;Z;do(U)), Temp1, Temp2), eval_body(V, Temp2, Result).
eval_command(range(X;Y;Z;do(_);V), Env, Result)		:- variable_lookup(X, Env, [(_, number)]), number_lookup(Y, _, Start), number_lookup(Z, _, End), Start > End, eval_body(V, Env, Result).

%% the while loop
eval_command(while(X;do(Y)), Env, Result) 		:- eval_boolean(X, Env, true), eval_body(Y, Env, Temp), eval_command(while(X;do(Y)), Temp, Result).
eval_command(while(X;do(_)), Env, Env) 			:-  eval_boolean(X, Env, false).
eval_command(while(X;do(Y);Z), Env, Result) 		:- eval_boolean(X, Env, true), eval_body(Y, Env, Temp), eval_command(while(X;do(Y)), Temp, Temp1), eval_body(Z, Temp1, Result).
eval_command(while(X;do(_);Z), Env, Result) 		:- eval_boolean(X, Env, false), eval_body(Z, Env, Result).

%% Conditional Statements
%% the if else condition
eval_command(if(X;then(Y);else(_)), Env, Result) 	:- eval_boolean(X, Env, true), eval_body(Y, Env, Result).
eval_command(if(X;then(_);else(Z)), Env, Result) 	:- eval_boolean(X, Env, false), eval_body(Z, Env, Result).
eval_command(if(X;then(Y);else(_);U), Env, Result) 	:- eval_boolean(X, Env, true), eval_body(Y, Env, Temp), eval_body(U, Temp, Result).
eval_command(if(X;then(_);else(Z);U), Env, Result) 	:- eval_boolean(X, Env, false),eval_body(Z, Env, Temp), eval_body(U, Temp, Result).

% the if condition
eval_command(if(X;then(Y)), Env, Result) 		:- eval_boolean(X, Env, true), eval_body(Y, Env, Result).
eval_command(if(X;then(_)), Env, Env) 			:- eval_boolean(X, Env, false).
eval_command(if(X;then(Y);Z), Env, Result) 		:- eval_boolean(X, Env, true), eval_body(Y, Env, Temp), eval_body(Z, Temp, Result).
eval_command(if(X;then(_);Z), Env, Result) 		:- eval_boolean(X, Env, false), eval_body(Z, Env, Result).

%% the ternary condition
%% separate condition for each datatypes.
eval_command(V:=X:Y;_;U, Env, Result) 			:- variable_lookup(V, Env, [(_, number)]), eval_boolean(X, Env, true), eval_value(Y, Env, [(Value, number)]), update_variable(V, Value, Env, Temp), eval_body(U, Temp, Result).
eval_command(V:=X:_;Z;U, Env, Result) 			:- variable_lookup(V, Env, [(_, number)]), eval_boolean(X, Env, false), eval_value(Z, Env, [(Value, number)]), update_variable(V, Value, Env, Temp), eval_body(U, Temp, Result).
eval_command(V:=X:Y;_;U, Env, Result) 			:- variable_lookup(V, Env, [(_, string)]), eval_boolean(X, Env, true), eval_value(Y, Env, [(Value, string)]), update_variable(V, Value, Env, Temp), eval_body(U, Temp, Result).
eval_command(V:=X:_;Z;U, Env, Result) 			:- variable_lookup(V, Env, [(_, string)]), eval_boolean(X, Env, false), eval_value(Z, Env, [(Value, string)]), update_variable(V, Value, Env, Temp), eval_body(U, Temp, Result).
eval_command(V:=X:Y;_;U, Env, Result) 			:- variable_lookup(V, Env, [(_, boolean)]), eval_boolean(X, Env, true), eval_value(Y, Env, [(Value, boolean)]), update_variable(V, Value, Env, Temp), eval_body(U, Temp, Result).
eval_command(V:=X:_;Z;U, Env, Result) 			:- variable_lookup(V, Env, [(_, boolean)]), eval_boolean(X, Env, false), eval_value(Z, Env, [(Value, boolean)]), update_variable(V, Value, Env, Temp), eval_body(U, Temp, Result).
%
eval_command(V:=X:Y;_, Env, Result) 			:- variable_lookup(V, Env, [(_, number)]), eval_boolean(X, Env, true), eval_value(Y, Env, [(Value, number)]), update_variable(V, Value, Env, Result).
eval_command(V:=X:_;Z, Env, Result) 			:- variable_lookup(V, Env, [(_, number)]), eval_boolean(X, Env, false), eval_value(Z, Env, [(Value, number)]), update_variable(V, Value, Env, Result).
eval_command(V:=X:Y;_, Env, Result) 			:- variable_lookup(V, Env, [(_, string)]), eval_boolean(X, Env, true), eval_value(Y, Env, [(Value, string)]), update_variable(V, Value, Env, Result).
eval_command(V:=X:_;Z, Env, Result) 			:- variable_lookup(V, Env, [(_, string)]), eval_boolean(X, Env, false), eval_value(Z, Env, [(Value, string)]), update_variable(V, Value, Env, Result).
eval_command(V:=X:Y;_, Env, Result) 			:- variable_lookup(V, Env, [(_, boolean)]), eval_boolean(X, Env, true), eval_value(Y, Env, [(Value, boolean)]), update_variable(V, Value, Env, Result).
eval_command(V:=X:_;Z, Env, Result) 			:- variable_lookup(V, Env, [(_, boolean)]), eval_boolean(X, Env, false), eval_value(Z, Env, [(Value, boolean)]), update_variable(V, Value, Env, Result).

%% SYNTACTIC SUGARS
%% Increment
eval_increase(inc(X), Env, Result) 			:- variable_lookup(X, Env, [(_, number)]), eval_arithmetic(X:=X+1, Env, Result).
eval_command(increment(X), Env, Result) 		:- eval_increase(X, Env, Result).
eval_command(increment(X);Y, Env, Result) 		:- eval_increase(X, Env, Temp), eval_body(Y, Temp, Result).

%% decerement
eval_abatement(dec(X), Env, Result) 			:- variable_lookup(X, Env, [(_, number)]) ,eval_arithmetic(X:=X-1, Env, Result).
eval_command(decrement(X), Env, Result) 		:- eval_abatement(X, Env, Result).
eval_command(decrement(X);Y, Env, Result) 		:- eval_abatement(X, Env, Temp), eval_body(Y, Temp, Result).

%% Short Assignment
eval_command(short_add(X;Y), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_value(Y, Env, [(Value, number)]), eval_arithmetic(X:=X+Value, Env, Result).
eval_command(short_add(X;Y);Z, Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_value(Y, Env, [(Value, number)]), eval_arithmetic(X:=X+Value, Env, Temp), eval_body(Z, Temp, Result).

eval_command(short_min(X;Y), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_value(Y, Env, [(Value, number)]), eval_arithmetic(X:=X-Value, Env, Result).
eval_command(short_min(X;Y);Z, Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_value(Y, Env, [(Value, number)]), eval_arithmetic(X:=X-Value, Env, Temp), eval_body(Z, Temp, Result).

eval_command(short_mul(X;Y), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_value(Y, Env, [(Value, number)]), eval_arithmetic(X:=X*Value, Env, Result).
eval_command(short_mul(X;Y);Z, Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_value(Y, Env, [(Value, number)]), eval_arithmetic(X:=X*Value, Env, Temp), eval_body(Z, Temp, Result).

eval_command(short_div(X;Y), Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_value(Y, Env, [(Value, number)]), eval_arithmetic(X:=X/Value, Env, Result).
eval_command(short_div(X;Y);Z, Env, Result) 		:- variable_lookup(X, Env, [(_, number)]), eval_value(Y, Env, [(Value, number)]), eval_arithmetic(X:=X/Value, Env, Temp), eval_body(Z, Temp, Result).

%% OPERATIONS
%% Datatypes Literals - value can be a variable value or literal value
eval_value(X, Env, [(Result, Type)]) 			:- variable_lookup(X, Env, [(Result, Type)]).
eval_value(X, _, [(Result, number)]) 			:- number_lookup(X, _, Result).
eval_value(X, _, [(Result, string)]) 			:- eval_string(X, _, Result).
                                                                                       
%% String Operations
eval_concat(join(X;Y), Env, Result) 			:- eval_value(X, Env, [(Temp, _)]), eval_value(Y, Env, [(Temp1, _)]), atom_concat(Temp, Temp1, Result).
eval_concat(join(X;Y), Env, Result) 			:- eval_value(X, Env, [(Temp, _)]), eval_concat(Y, Env, Temp1), atom_concat(Temp, Temp1, Result).

%% String Operations
eval_string({X}, _, Result) 				:- string(X, [Result|_], _).

%% Arithmetic Operations
eval_arithmetic(X:=Y, Env, Result) 			:- variable_lookup(X, Env, [(_, number)]), eval_arithmetic(Y, Env, Temp), update_variable(X, Temp, Env, Result).
eval_arithmetic(X:=Y;Z, Env, Result) 			:- variable_lookup(X, Env, [(_, number)]), eval_arithmetic(Y, Env, Temp), update_variable(X, Temp, Env, Temp1), eval_body(Z, Temp1, Result).

eval_arithmetic(X, Env, Result) 			:- number_lookup(X, _, Result); variable_lookup(X, Env, [(Result, number)]).
eval_arithmetic((X), Env, Result) 			:- eval_arithmetic(X, Env, Result).

eval_arithmetic(X:Y, Env, Result) 			:- eval_term(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), Result is mod(Temp, Temp1).
eval_arithmetic(X+Y, Env, Result) 			:- eval_term(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), Result is Temp + Temp1.
eval_arithmetic(X-Y, Env, Result) 			:- eval_term(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), Result is Temp - Temp1.
eval_arithmetic(X, Env, Result) 			:- eval_term(X, Env, Result).

eval_term(X/Y, Env, Result) 				:- eval_literals(X, Env, Temp), eval_term(Y, Env, Temp1), Result is Temp // Temp1.
eval_term(X*Y, Env, Result) 				:- eval_literals(X, Env, Temp), eval_term(Y, Env, Temp1), Result is Temp * Temp1.
eval_term((X), Env, Result) 				:- eval_arithmetic(X, Env, Result).
eval_term(X, Env, Result) 				:- eval_literals(X, Env, Result).

eval_literals((X), Env, Result) 			:- eval_arithmetic(X, Env, Result).
eval_literals(X, Env, Result) 				:- number_lookup(X, _, Result); variable_lookup(X, Env, [(Result, number)]).

%% Relational Operators/Operations
eval_boolean(true, _, true).
eval_boolean(false, _, false).
eval_boolean(X, Env, Result) 				:- variable_lookup(X, Env, [(Result, boolean)]).

eval_boolean(X==Y, Env, Result) 			:- eval_arithmetic(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), boolean_equal_eval(Temp, Temp1, Result).
eval_boolean(X>Y, Env, Result) 				:- eval_arithmetic(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), boolean_greater_eval(Temp, Temp1, Result).
eval_boolean(X>>Y, Env, Result) 			:- eval_arithmetic(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), boolean_greater_equal_eval(Temp, Temp1, Result).
eval_boolean(X<Y, Env, Result) 				:- eval_arithmetic(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), boolean_less_eval(Temp, Temp1, Result).
eval_boolean(X<<Y, Env, Result) 			:- eval_arithmetic(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), boolean_less_equal_eval(Temp, Temp1, Result).
eval_boolean(X//Y, Env, Result) 			:- eval_arithmetic(X, Env, Temp), eval_arithmetic(Y, Env, Temp1), \+ boolean_equal_eval(Temp, Temp1, Result).

eval_boolean(not(X), Env, Result) 			:- eval_boolean(X, Env, Temp), negation(Temp, Result).
eval_boolean(and(X;Y), Env, Result) 			:- eval_boolean(X, Env, Temp), eval_boolean(Y, Env, Temp1), and(Temp, Temp1, Result).
eval_boolean(or(X;Y), Env, Result) 			:- eval_boolean(X, Env, Temp), eval_boolean(Y, Env, Temp1), or(Temp, Temp1, Result).
eval_boolean(xor(X;Y), Env, Result) 			:- eval_boolean(X, Env, Temp), eval_boolean(Y, Env, Temp1), xor(Temp, Temp1, Result).

% boolean helper predicates
boolean_equal_eval(X, X, true).
boolean_equal_eval(X, Y, false) 			:- X \= Y.

boolean_greater_eval(X, Y, true) 			:- X > Y. 
boolean_greater_eval(X, Y, false) 			:- X =< Y.

boolean_greater_equal_eval(X, Y, true) 			:- X >= Y.
boolean_greater_equal_eval(X, Y, false) 		:- X < Y.

boolean_less_eval(X, Y, true) 				:- X < Y.
boolean_less_eval(X, Y, false) 				:- X >= Y.

boolean_less_equal_eval(X, Y, true) 			:- X =< Y.
boolean_less_equal_eval(X, Y, false) 			:- X > Y.

negation(X, false) 					:- X == true.
negation(X, true) 					:- X == false.

and(X, Y, true) 					:- X == true, Y == true.
and(X, Y, false) 					:- X == true, Y == false.
and(X, Y, false) 					:- X == false, Y == true.
and(X, Y, false) 					:- X == false, Y == false.

or(X, Y, true) 						:- X == true, Y == true.
or(X, Y, true) 						:- X == true, Y == false.
or(X, Y, true) 						:- X == false, Y == true.
or(X, Y, false) 					:- X == false, Y == false.

xor(X, Y, false) 					:- X == true, Y == true.
xor(X, Y, true) 					:- X == true, Y == false.
xor(X, Y, true) 					:- X == false, Y == true.
xor(X, Y, false) 					:- X == false, Y == false.

%% Checks a digit and assign it to Value
number_lookup(X, _, Value) 				:- number(X, [Value|_], _).
number_lookup(signed(X), _, Result)			:- number_lookup(X, _, Value), Result is -1 * Value.

%% Checks if the variable is a valid identifier and adds it to the environment if it is not added already!
add_variable(X, Value, Type, [], [(X, Value, Type)]).
add_variable(X, _, _, [(X, Value, Type)|T], [(X, Value, Type)|T]).
add_variable(X, Value, Type, [H|T1], [H|T2]) 		:- H \= (X, _, _), add_variable(X, Value, Type, T1, T2).

%% Checks the environment for a variable and unify it to value
variable_lookup(_, [], _)				:- fail.
variable_lookup(X, [(X, Value, Type)|_], [(Value, Type)]).
variable_lookup(X, [_|T], Value) 			:- variable_lookup(X, T, Value).

%% Updates a variable if it exists in the environment, otherwise fails
update_variable(_, _, [], _) 				:- fail.
update_variable(X, Value, [(X, _, Type)|T], [(X, Value, Type)|T]).
update_variable(X, Value, [H|T1], [H|T2])		:- update_variable(X, Value, T1, T2).
