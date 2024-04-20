:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).

% Consult Files
:- consult('./users/api_functions.pl').

% Define API endpoints
:- http_handler(root('users/exists'), user_exists_handler, [method(get)]).

% Start the server
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).