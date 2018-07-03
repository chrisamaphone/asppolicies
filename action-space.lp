
character(alice).
character(bob).
item(lamp).
item(sword).
item(key).
location(den).
location(foyer).
location(garden).

adjacent(den,foyer).
adjacent(den,garden).
adjacent(X,Y) :- adjacent(Y,X).

action(take(C,O)) :- character(C), item(O).
action(move(C,L)) :- character(C), location(L).

time(1..10).

% :- possible(T, A), not action(A).

%% Definition of take
possible(T, take(C, O)) :-
  % time(T),
  action(take(C,O)),
  holds(T, at(C, L)),
  holds(T, at(O, L)).

effect(take(C,O), has(C,O)) :- action(take(C,O)).

deletes(take(C, O), at(C,L))
  :- happens(T, take(C,O)), holds(T, at(C,L)).


%% Definition of move
possible(T, move(C,L)) :-
  action(move(C,L)),
  holds(T, at(C, L')),
  adjacent(L,L').

effect(move(C,L), at(C,L)) :- action(move(C,L)).

deletes(move(C,L), at(C,L'))
  :- happens(T, move(C,L)), holds(T, at(C,L')).


%% Choosing actions

% 1 { happens(T, A) : possible(T,A) } 1 :- time(T).
% The above doesn't work for some reason?

1 { happens(0,A) : possible(0,A) } 1.
1 { happens(1,A) : possible(1,A) } 1.
1 { happens(2,A) : possible(2,A) } 1.

%% Reasoning about effects

holds(T+1, P)
  :- happens(T, A), effect(A, P).
holds(T+1, P)
  :- happens(T, A),
     holds(T, P),
     not deletes(A, P).


holds(0, at(alice, garden)).
holds(0, at(bob, foyer)).
holds(0, at(key, garden)).
holds(0, at(lamp, den)).

% #show holds/2.
% #show possible/2.
#show happens/2.


% % Simulating hypotheticals
% 
% could_hold(T,just(A)) :- holds(T,A).
% 
% could_happen(T,just(A)) :- possible(T,A).
% could_happen(T,just(A)) :- all_premises_could_hold(T, A).
% 
% all_premises_could_hold(T, take(C,O))
%   :- action(take(C,O)), could_hold(T, at(C,L), _), could_hold(T, at(O,L), _).
% all_premises_could_hold(T, move(C,L))
%   :- action(move(C,L)), could_hold(T, at(C,L'), _), adjacent(L,L').
%  
% could_hold(T+1, P, A)
%   :- could_happen(T, A), effect(A, P).
% could_hold(T+1, P, A)
%   :- could_happen(T, A), could_hold(T, P, _), not deletes(A, P).
%  
 
% % Planning
%   
% 
% #show plan/2.
% 

