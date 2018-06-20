ball(1..10).

1 {red(B); blue(B)} 1 :- ball(B).

1 {bin1(B); bin2(B)} 1 :- ball(B).

ce(B) :- red(B), not bin2(B).

:- not ce(_).

#show red/1.
#show ce/1.
#show bin1/1.
