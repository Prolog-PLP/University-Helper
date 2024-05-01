:- consult('../../controllers/notebook_controller.pl').

extract_notebook_params(Request, ID, Type, Name, ExtraData) :-
    http_parameters(Request, [
        id(ID, [integer, optional(true)]),
        type(Type, [string, optional(true)]),
        name(Name, [string, optional(true)]),
        subjectsPages(SubjectsPages, [list(string), optional(true)]),
        hasPages(HasPages, [boolean, optional(true)]),
        keywords(Keywords, [list(string), optional(true)])
    ]),
    ExtraData = notebook_extra_data{subjectsPages: SubjectsPages, hasPages: HasPages, keywords: Keywords},
    format("ID: ~w, Type: ~w, Name: ~w, ExtraData: ~w~n", [ID, Type, Name, ExtraData]).


add_notebook_handler(Request) :-
    http_read_json_dict(Request, Notebook),
    extract_notebook_params(Request, ID, Type, Name, ExtraData),
    add_notebook(ID, Type, Name, ExtraData, Response), 
    reply_json(Response).

get_notebooks_handler(Request) :-
    extract_notebook_params(Request, ID, Type, Name),
    filter_notebooks(ID, Type, Name, Notebooks),
    maplist(notebook_to_json, Notebooks, NotebooksJson),
    reply_json(NotebooksJson).

update_notebook_handler(ID, Request) :-
    atom_number(ID, UID),
    http_read_json_dict(Request, Notebook),
    update_notebook(UID, Notebook, Response),
    reply_json(Response).

delete_notebook_api_handler(Request) :-
    delete_notebook_handler(Request).