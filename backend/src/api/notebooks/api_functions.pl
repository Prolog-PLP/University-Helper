:- consult('../../controllers/notebook_controller.pl').

extract_notebook_params(Request, ID, Name, Type, CreatedAt, UpdatedAt, Subjects, MinNumPages, MaxNumPages, PageLength, NotesIDs, NotesSubjects) :-
    http_parameters(Request, [
        id(ID, [integer, optional(true)]),
        name(Name, [string, optional(true)]),
        type(Type, [string, optional(true)]),
        createdAt(CreatedAt, [string, optional(true)]),
        updatedAt(UpdatedAt, [string, optional(true)]),
        subjects(Subjects, [list(string), optional(true)]),
        minNumPages(MinNumPages, [integer, optional(true)]),
        maxNumPages(MaxNumPages, [integer, optional(true)]),
        pageLength(PageLength, [integer, optional(true)]),
        notesIDs(NotesIDs, [list(integer), optional(true)]),
        notesSubjects(NotesSubjects, [list(string), optional(true)])
    ]).

add_notebook_handler(Request) :-
    http_read_json_dict(Request, NotebookJson),
    add_notebook(NotebookJson, Response), 
    reply_json(Response).

get_notebooks_handler(Request) :-
    extract_notebook_params(Request, ID, Name, Type, CreatedAt, UpdatedAt, Subjects, MinNumPages, MaxNumPages, PageLength, NotesIDs, NotesSubjects),
    get_notebooks(ID, Name, Type, CreatedAt, UpdatedAt, Subjects, MinNumPages, MaxNumPages, PageLength, NotesIDs, NotesSubjects, Notebooks),
    maplist(notebook_to_json, Notebooks, NotebooksJson),
    reply_json(json{notebooks: NotebooksJson}).

update_notebook_handler(ID, Request) :-
    atom_number(ID, UID),
    http_read_json_dict(Request, NotebookJson),
    update_notebook(UID, NotebookJson, Response),
    reply_json(Response).

delete_notebook_handler(Request) :-
    extract_notebook_params(Request, ID, Name, Type, CreatedAt, UpdatedAt, Subjects, MinNumPages, MaxNumPages, PageLength, NotesIDs, NotesSubjects),
    delete_notebooks(ID, Name, Type, CreatedAt, UpdatedAt, Subjects, MinNumPages, MaxNumPages, PageLength, NotesIDs, NotesSubjects, Response),
    reply_json(Response).