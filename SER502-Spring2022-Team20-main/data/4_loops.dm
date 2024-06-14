%
Loops
%

function(x number)
start

	% for loop %
	x = 5;
	println "for loop";
	for (x; x =< 10; x++)
	start
		println x;
	stop;

	% while loop %
	x = 5;
	println "while loop";
	while (x =< 10)	
	start
		println x;
		x += 1;
	stop;

	% range loop%
	x = 5;
	println "range loop";
	for x in range(5..10)
	start
		println x;
	stop;

	return "loop checking completed";
stop
