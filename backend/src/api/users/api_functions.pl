:- consult('../../controllers/user_controller.pl').
:- consult('../../utils.pl').

user_exists_handler(Request) :-
    http_parameters(Request, [id(ID, [integer])]),
    get_users(ID, _, _, _, _, _, _, _); get_users(ID, _, _, _, _, _),
    format('Content-type: application/json~n~n'),
    format('{ "exists": true }').

user_exists_handler(_) :-
    format('Content-type: application/json~n~n'),
    format('{ "exists": false }').

add_user_handler(Request) :-
    http_read_json_dict(Request, User),
    add_user(User),
    format('Content-type: application/json~n~n'),
    format('{ "success": true }').

update_user_handler(Request) :-
    http_read_json_dict(Request, User),
    update_user(User),
    format('Content-type: application/json~n~n'),
    format('{ "success": true }').

delete_user_handler(Request) :-
    http_read_json_dict(Request, User),
    delete_user(User),
    format('Content-type: application/json~n~n'),
    format('{ "success": true }').

get_users_handler(_) :-
    findall(user(ID, Name, Email, Password, Type, Enrollment),
            user(ID, Name, Email, Password, Type, Enrollment),
            Users),
    maplist(user_to_json, Users, UsersJson),
    reply_json(json{users: UsersJson}).