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

delete_notebooks(ID, _, _, _, _, _, _) :-
    nonvar(ID),
    retractall(notebook(ID, _, _, _, _)),
    retractall(notebook(ID, _, _, _, _, _, _)),
    retractall(notebook_subject(ID, _, _, _)),
    retractall(note_page(ID, _, _, _, _, _, _)),
    retractall(notebook_page(ID, _, _, _, _, _, _)),
    save_notebooks, !.

delete_notebooks(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt) :-
    get_notebooks_ids(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt, NotebooksIDs),
    delete_notebooks_entries(NotebooksIDs),
    save_notebooks.

delete_notebooks_entries([]).
delete_notebooks_entries([ID | Tail]) :-
    delete_notebooks(ID, _, _, _, _, _, _),
    delete_notebooks_entries(Tail).

update_notebook(ID, Name, Type) :-
    retract(notebook(ID, _, _)),
    assertz(notebook(ID, Name, Type)),
    save_notebooks.

get_notebooks5(ID, Name, Type, CreatedAt, UpdatedAt, Notebooks) :-
    findall(notebook(ID, Name, Type, CreatedAt, UpdatedAt),
            notebook(ID, Name, Type, CreatedAt, UpdatedAt),
            Notebooks).

get_notebooks7(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt, Notebooks) :-
    findall(notebook(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt),
            notebook(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt),
            Notebooks).

get_notebooks(ID, Name, Type, CreatedAt, UpdatedAt, _, _, _, PageLength, _, _, Notebooks) :-
    get_notebooks5(ID, Name, Type, CreatedAt, UpdatedAt, Notebooks5),
    get_notebooks7(ID, Name, Type, _, PageLength, CreatedAt, UpdatedAt, Notebooks7),
    append(Notebooks5, Notebooks7, PartialNotebooks),
    Notebooks = PartialNotebooks.

get_notebooks5_ids(ID, Name, Type, CreatedAt, UpdatedAt, NotebooksIDs) :-
    findall(ID,
            notebook(ID, Name, Type, CreatedAt, UpdatedAt),
            NotebooksIDs).

get_notebooks7_ids(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt, NotebooksIDs) :-
    findall(ID,
            notebook(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt),
            NotebooksIDs).

get_notebooks_ids(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt, NotebooksIDs) :-
    get_notebooks5_ids(ID, Name, Type, CreatedAt, UpdatedAt, Notebooks5IDs),
    get_notebooks7_ids(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt, Notebooks7IDs),
    append(Notebooks5IDs, Notebooks7IDs, PartialNotebooksIDs),
    NotebooksIDs = PartialNotebooksIDs.