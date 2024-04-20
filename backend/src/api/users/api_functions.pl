:- consult('../controllers/UserController.pl').

user_exists_handler(Request) :-
    http_parameters(Request, [id(ID, [integer])]),
    user_exists(ID),
    format('Content-type: application/json~n~n'),
    format('{ "exists": true }').

user_exists_handler(_) :-
    format('Content-type: application/json~n~n'),
    format('{ "exists": false }').