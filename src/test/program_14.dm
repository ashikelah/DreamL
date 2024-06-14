% 
Test program
Testing nested if else condition
%

function (x number, y number)
start
      x = 4; y=5;
     if (x > y)
      start
              print "the greatest number is X ";
	print x;
      stop;
      else
      start
              if (y == 5)
              start
                   print "the greatest number is Y ";
	     print y;
              stop;
       stop;
      return "greatest number is identified";
stop
