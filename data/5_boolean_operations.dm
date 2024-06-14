%
Boolean operations
%
start
	x boolean, y boolean;
	x = true; y = false;

	% and operation %
	if (x && y) 
	start
		println "and operation is not working";
	stop;
	else
	start
		println "and operation is working";
	stop;

	% or operation%
	if (x || y)
	start
		println "or operation is working";
	stop;
	else
	start
		println "or operation is broken";
	stop;

	% not operation %
	if (!y)
	start
		println "not operation is working";
	stop;
	else
	start
		println "not operation broken";
	stop;

	% XOR operation %
	if (x ^ y)
	start
		println "XOR is working";
	stop;
	else
	start
		println "XOR is broken";
	stop;
stop
