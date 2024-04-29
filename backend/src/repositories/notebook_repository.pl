:- consult('../utils.pl').
:- database_path(BasePath),
   concat_paths(BasePath, 'notebooks.pl', File),
   consult(File).

save_notebooks :-
    database_path(BasePath),
    concat_paths(BasePath, 'notebooks.pl', File),
    tell(File),
    listing(notebook),
    listing(current_notebook_id),
    listing(next_notebook_id),
    told.

add_notebook(ID, Type, Name) :-
    assertz(notebook(ID, Type, Name)),
    save_notebooks.

delete_notebook(ID, Type, Name) :-
    retractall(notebook(ID, Type, Name)),
    save_notebooks.

get_notebook(ID, Type, Name, Notebook) :-
    notebook(ID, Type, Name) -> Notebook = notebook(ID, Type, Name).

get_notebooks(ID, Type, Name, Notebooks) :-
    findall(notebook(ID, Type, Name), notebook(ID, Type, Name), Notebooks).

update_notebook(ID, Type, Name) :-
    retract(notebook(ID, _OldType, _OldName)),
    assertz(notebook(ID, Type, Name)),
    save_notebooks.