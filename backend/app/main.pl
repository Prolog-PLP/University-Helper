:- consult('../src/api/api.pl').
:- initialization(main).

main :- start_server(8000).