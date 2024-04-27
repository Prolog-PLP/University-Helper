:- consult('api_functions.pl').
http:location(notebooks, root(notebooks), []).

:- http_handler(notebooks(add), add_notebook_handler, [method(post)]).
:- http_handler(notebooks, get_notebooks_handler, [method(get)]).
:- http_handler(notebooks(update/ID), update_notebook_handler(ID), [method(post)]).
:- http_handler(notebooks(delete), delete_notebook_handler, [method(delete)]).