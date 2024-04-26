:- consult('api_functions.pl').

http:location(users, api(users), []).

:- http_handler(users(.), get_users_handler, [method(get)]).
:- http_handler(users(exists), user_exists_handler, [method(get)]).
:- http_handler(users(add), add_user_handler, [method(post)]).
:- http_handler(users(delete), delete_users_handler, [method(delete)]).
:- http_handler(users(update/ID), update_user_handler(ID), [method(patch)]).
:- http_handler(users(notifyUser), notify_user_handler, [method(post)]).