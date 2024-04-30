:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_cors)).

:- set_setting(http:cors, [*]).

:- consult('./users/api_routes.pl').
:- consult('./notes/api_routes.pl').
:- consult('./notebooks/api_routes.pl').

:- multifile http:location/3.
:- dynamic   http:location/3.

http:location(api, root(api), []).

start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).