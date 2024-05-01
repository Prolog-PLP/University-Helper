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

update_notebook(ID, Type, Name) :-
    retract(notebook(ID, _OldType, _OldName)),
    assertz(notebook(ID, Type, Name)),
    save_notebooks.

get_notebooks5(ID, Type, Name, CreatedAt, UpdatedAt, Notebooks) :-
    findall(notebook(ID, Type, Name, CreatedAt, UpdatedAt),
            notebook(ID, Type, Name, CreatedAt, UpdatedAt),
            Notebooks).

get_notebooks7(ID, Type, Name, NumPages, PageLength, CreatedAt, UpdatedAt, Notebooks) :-
    findall(notebook(ID, Type, Name, NumPages, PageLength, CreatedAt, UpdatedAt),
            notebook(ID, Type, Name, NumPages, PageLength, CreatedAt, UpdatedAt),
            Notebooks).

get_notebooks(ID, Type, Name, CreatedAt, UpdatedAt, _, _, _, PageLength, _, _, Notebooks) :-
    get_notebooks5(ID, Type, Name, CreatedAt, UpdatedAt, Notebooks5),
    get_notebooks7(ID, Type, Name, _, PageLength, CreatedAt, UpdatedAt, Notebooks7),
    append(Notebooks5, Notebooks7, PartialNotebooks),
    Notebooks = PartialNotebooks.
