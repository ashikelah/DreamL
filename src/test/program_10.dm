%
Test program
Testing orinary for loop
%

function ()
start
     x number;
     x = 0;
     for (x; x < 5; x++)
     start
           increment number;
           increment = 1;
           increment = increment + x;
           print increment;
           for (increment; increment < x; increment = increment + 1)
           start
	    print increment;
           stop;
     stop;
     return x;
stop