
profile_info(name).
profile_info(age).
profile_info(weight).

{user_provides(I)} :- profile_info(I).
#show user_provides/1.

device_info(browser).
device_info(device_type).

{user_does(kudos)}.
#show user_does/1.

%% Information We Collect
collects(I) :- profile_info(I), user_provides(I).
collects(I) :- device_info(I).
collects(trace_action(A)) :- user_does(A).

#show collects/1.

%% Conditions under which services can be provided

service(display(Info)) :- user_data(Info).

can_provide_service(display(Info))
  :- collects(Info).

#show can_provide_service/1.



