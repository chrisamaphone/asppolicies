%% Article 4, Definitions
%%  (1)
%% ‘personal data’ means any information relating to an identified or
%% identifiable natural person (‘data subject’); an identifiable natural
%% person is one who can be identified, directly or indirectly, in particular
%% by reference to an identifier such as a name, an identification number,
%% location data, an online identifier or to one or more factors specific to
%% the physical, physiological, genetic, mental, economic, cultural or social
%% identity of that natural person;

%% name(X, N) means N is X's name
%% id_number(X, ID) means ID is X's ID number
%% identified(X) means X is an "identified or identifiable natural person"

identified(X) :- name(X, N).
identified(X) :- id_number(X, ID).

%% data_subject(X) means X is a "data subject" for the purposes of this
%% regulation.
data_subject(X) :- identified(X).

%% personal_data_of(D, X) means D is personal data for X.
%% personal_data(D) means D is personal data (for someone).
%% relates(D, X) means data D relates to data subject X.
personal_data_of(D, X) :- data_subject(X), relates(D, X).
personal_data(D) :- personal_data_of(D, X).

% (2) ‘processing’ means any operation or set of operations which is performed on
% personal data or on sets of personal data, whether or not by automated means,
% such as collection, recording, organisation, structuring, storage, adaptation
% or alteration, retrieval, consultation, use, disclosure by transmission,
% dissemination or otherwise making available, alignment or combination,
% restriction, erasure or destruction;

%% processing(O, D, X) means O is an operation that counts as processing,
%%  and it uses data D pertaining to data subject X.
%% requires(O, D) means operation O requires data D.
processing(O, D, X) :- requires(O, D), personal_data_of(D, X).

%% ... skipping ahead ...
%% Chaper II: Principles
%% Article 5: Principles relating to processing of personal data
%% Hypothesis: "principles" can be encoded as integrity constraints?

%% Article 6: Lawfulness of processing

% 1.   Processing shall be lawful only if and to the extent that at least
% one of the following applies:
% (a) the data subject has given consent to the processing of his or her
% personal data for one or more specific purposes;

%% gives_consent(X, O, D) means subject X gives consent for operation O to
%% be done with  data D.
%% lawful(O) means an operation is lawful.
lawful(O) :- processing(O, D, X), gives_consent(X, O, D).

% (b) processing is necessary for the performance of a contract to which the
% data subject is party or in order to take steps at the request of the data
% subject prior to entering into a contract;

%% necessary(O,C): operation O is necessary for contract C
%% XXX - could this be encoded logically? "if not happens(O) then not
%%  possible to fulfill C"
%% party(X, C): subject X is party to contract C
lawful(O) :- processing(X, O, D), necessary(O, C), party(X, C).

% XXX - stopped here.
% (c) processing is necessary for compliance with a legal obligation to which
% the controller is subject;
% 
% (d) processing is necessary in order to protect the vital interests of the
% data subject or of another natural person;
% 
% (e) processing is necessary for the performance of a task carried out in the
% public interest or in the exercise of official authority vested in the
% controller;
% 
% (f) processing is necessary for the purposes of the legitimate interests
% pursued by the controller or by a third party, except where such interests
% are overridden by the interests or fundamental rights and freedoms of the
% data subject which require protection of personal data, in particular where
% the data subject is a child.
% 
% Point (f) of the first subparagraph shall not apply to processing carried
% out by public authorities in the performance of their tasks.
% 
