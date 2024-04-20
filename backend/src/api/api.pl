:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).

% Consult Files
:- consult('./users/api_functions.pl').

% Define API endpoints
:- http_handler(root('users'), get_users_handler, [method(get)]).
:- http_handler(root('users/exists'), user_exists_handler, [method(get)]).
:- http_handler(root('users/add'), add_user_handler, [method(post)]).
:- http_handler(root('users/delete'), delete_user_handler, [method(post)]).
:- http_handler(root('users/update'), update_user_handler, [method(post)]).

% Start the server
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).