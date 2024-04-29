:- consult('../../controllers/notebook_controller.pl').

extract_notebook_params(Request, ID, Type, Name) :-
    http_parameters(Request, [
        id(ID, [integer, optional(true)]),
        type(Type, [string, optional(true)]),
        name(Name, [string, optional(true)])
        % add here the rest of the params that you want, and remember to put the rest that the notebooks needs
    ]).

add_notebook_handler(Request) :-
    http_read_json_dict(Request, Notebook),
    add_notebook(Notebook, Response),
    reply_json(Response).

get_notebooks_handler(_):-
    find_all_notebooks(Notebooks),
    maplist(notebook_to_json, Notebooks, NotebooksJson),
    reply_json(NotebooksJson).

update_notebook_handler(ID, Request) :-
    atom_number(ID, UID),
    http_read_json_dict(Request, Notebook),
    update_notebook(UID, Notebook, Response),
    reply_json(Response).

delete_notebook_handler(Request) :-
    extract_notebook_params(Request, ID, Type, Name),
    delete_notebook(ID, Type, Name, Response),
    reply_json(Response).