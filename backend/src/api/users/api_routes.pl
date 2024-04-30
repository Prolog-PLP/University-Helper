:- consult('api_functions.pl').

http:location(users, api(users), []).

:- http_handler(users(.), get_users_handler, [method(options, get)]).
:- http_handler(users(exists), user_exists_handler, [method(options, get)]).
:- http_handler(users(add), add_user_handler, [method(options, post)]).
:- http_handler(users(delete), delete_users_handler, [method(options, delete)]).
:- http_handler(users(update/ID), update_user_handler(ID), [method(options, patch)]).
:- http_handler(users(validated_users), get_validated_users_handler, [method(options, get)]).
:- http_handler(users(unvalidated_users), get_unvalidated_users_handler, [method(options, get)]).
:- http_handler(users(validate_user/ID), validate_user_handler(Method, ID), [method(Method), methods(options, patch)]).
:- http_handler(users(unvalidate_user), unvalidate_user_handler, [method(options, delete)]).
