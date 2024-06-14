%
Test program
Testing syntactic sugars
%
start
    x number;
    r number;
    x = 5;
    r = x < 6 ? 5 : 6;

    y number;
    y += r;
    y--;
    print y;
stop
