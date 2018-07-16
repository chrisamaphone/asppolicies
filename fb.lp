potential_user(alice).
potential_user(bob).
potential_user(carla).

access_level(User, public) :- user(User).
access_level(User, friends(User)) :- user(User).
access_level(User, private(User)) :- user(User).

% Actions
{happens(A)} :- possible(A).

% Joining
possible(join(Potential)) :- potential_user(Potential).
user(Person) :- happens(join(Person)).

% Adding a friend
possible(add_friend(U1,U2)) 
  :- user(U1), user(U2), not U1 = U2, not happens(add_friend(U2,U1)).
friends_with(U1, U2) :- happens(add_friend(U1,U2)).

% Friendship is reflective and symmetric
friends_with(U,U) :- user(U).
friends_with(U2, U1) :- friends_with(U1, U2).

% Friendship implies an access level
has_access_level(Friend, friends(User)) :- friends_with(Friend,User).
access_implies(friends(User), public) :- user(User).
access_implies(private(User), friends(User)) :- user(User).
access_implies(Acc1, Acc3) :- 
  access_implies(Acc1, Acc2), access_implies(Acc2, Acc3).
has_access_level(Someone, Acc2) 
  :- has_access_level(Someone, Acc1), access_implies(Acc1, Acc2).

% Posting
% "When you share and communicate using our Products, you choose the
% audience for what you share. For example, when you post on Facebook, you
% select the audience for the post, such as a group, all of your friends,
% the public, or a customized list of people."
% -- we model private, all friends, and public
content(dummy).
possible(post(User, Post, Access)) :- 
  user(User), content(Post), access_level(User, Access).

possible(sees(Someone, post(User, Post)))
  :- happens(post(User, Post, PostAccess)),
      has_access_level(Someone, PostAccess).

% Joining a group
% Three settings: public, closed, and secret
group(knitters). group(brca_gene). group(raleigh_cyclists).
group_access_level(knitters, public).
group_access_level(raleigh_cyclists, closed).
group_access_level(brca_gene, secret).

admin(bob, knitters).
admin(alice, brca_gene).
admin(carla, raleigh_cyclists).

member(Person, Group) :- admin(Person, Group).

% Inviting someone to a group
possible(invite(User1, User2, Group))
  :- member(User1, Group), friends_with(User1, User2).

% Finding a closed or public group
possible(sees(Finder, groupName(Group))) :- 
  user(Finder), group(Group), not group_access_level(Group, secret).

% Requesting to join a closed or secret group
possible(requestsJoin(Joiner, Group))
  :- happens(sees(Joiner,groupName(Group))),
      group_access_level(Group, closed).

possible(requestsJoin(Joiner, Group))
  :- happens(invite(Member, Joiner, Group)),
      not group_access_level(Group, public).

% Approving a join request
possible(approves(Admin, Joiner, Group))
  :- happens(requestsJoin(Joiner, Group)),
      admin(Admin, Group).

% Joining a group -- if found or approved
possible(join(Joiner, Group)) :- 
  happens(sees(Joiner, groupName(Group))), group_access_level(Group,public).
possible(join(Joiner, Group)) :-
  happens(approves(Admin, Joiner, Group)).

member(Joiner, Group) :- happens(join(Joiner, Group)).

% Seeing the members of a group
possible(sees(User, is_member(User2, Group))) :-
  user(User), member(User2, Group), not group_access_level(Group, secret).

 
% Alice and Bob are friends; Alice and Carla are not.
:- not friends_with(alice,bob). 
:- not user(carla).
:- friends_with(alice,carla).

% Is it possible for nonmembers to see the members of a closed group?
sees_closed :- 
  happens(sees(User, is_member(Member,Group))),
  group_access_level(Group, closed),
  not member(User, Group).
:- not sees_closed.
% Many SATISFIABLE solutions, so yes.
 
#show happens/1.
%#show user/1.
%#show possible/1.
%#show has_access_level/2.


%% End of 7/16/2018 experiment, encoding the situation for the BRCA gene
%% carrier group:
% https://www.cnbc.com/2018/07/11/facebook-private-groups-breast-cancer-privacy-loophole.html

% % Reacting
% possible(react(User, Post, Reaction)) 
%   :- user(User), post(Post), reaction(Reaction).
% 
% sees(Friend, react(User, Post, Reaction))
%   :- happens(react(User, Post, Reaction)),
%      has_access_level(Post, Level1),
%      has_access_level(Friend, Level2),
%      access_implies(Level2, Level1).
% possible(join_group).
% 
% %#show user_does/1.
% 
% % Profile info
% 
% % Name is required
% happens(user_provides(User, name)) :- user(User).
% 
% % Other fields are optional
% {user_provides(User, I)} :- user(User), profile_info(I).
% #show user_provides/1.
% 
% % XXX below
 
