%
String concatenation
%

start
	x string, y string;
	x = "hello ";
	y = "world";
	x = x # y;
	println x;

	% multiple concat%
	x = "repeat";
	y = "me";
	x = x # y # x # y # "and I finished repeating";
	println x;
stop
