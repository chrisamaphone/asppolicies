plan(nil, 0).
plan(seq(Plan, Action), N+1) :- plan(Plan, N), action(Action), N < 3.

% after(Plan, Prop) 
after(nil, Prop) :- initially(Prop).
after(seq(Plan, Action), Prop) :-
  plan(seq(Plan,Action), _),
  possible_after(Plan, Action),
  effect(Action, Prop).
after(seq(Plan,Action), Prop) :-
  plan(seq(Plan,Action), _),
  after(Plan, Prop),
  possible_after(Plan, Action),
  not deletes(Action, Prop).

%#show after/2.
% possible_after(Plan, Action)
possible_after(Plan, move(C,L))
  :- after(Plan, at(C, L')), action(move(C,L)), location(L'), not L = L'.

possible_after(Plan, take(C,I))
  :- after(Plan, at(C,L)), after(Plan, at(I,L)).

possible(Plan) :- plan(Plan,_), possible_after(Plan,_).

% effect(Action,Prop)
effect(move(C,L), at(C,L)) :- action(move(C,L)).
effect(take(C,I), has(C,I)) :- action(take(C,I)).

% deletes(Action,Prop)
deletes(move(C,L), at(C,L')) :- action(move(C,L)), location(L'), not L = L'.
deletes(take(C,I), at(I,L))  :- action(take(C,I)), location(L).

% initially(Prop)
initially(at(alice,garden)).
initially(at(bob,foyer)).
initially(at(key,garden)).

% only generate 1 plan
1 { happens(P) : possible(P) } 1.

#show happens/1.

%% Sample domain

character(alice).
character(bob).
item(key).
location(garden).
location(foyer).

action(move(C,L)) :- character(C), location(L).
action(take(C,I)) :- character(C), item(I).


%% This works like a traditional planner
% % goals
% goal(has(bob,key)).
% goal(at(alice,foyer)).
% 
% % rule out plans that don't achieve goals
% :- happens(P), goal(G), not after(P, G).

% agents
agent(take(C,I), C) :- action(take(C,I)).
agent(move(C,L), C) :- action(move(C,L)).

% What I want to codify: 
% No action Act with agent Ag takes place unless Ag must do Act to
% accomplish their intention
% What I don't know how to say:
% "must do [action] to accomplish [intention]"
% 

