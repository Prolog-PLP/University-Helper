:- consult('../src/api/api.pl'),
   consult('../database/database.pl'),
   consult('../src/utils.pl').
:- initialization(main).

main :- start_server(8000).