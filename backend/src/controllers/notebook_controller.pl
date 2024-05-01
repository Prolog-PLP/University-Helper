:- consult('../repositories/notebook_repository.pl').

add_notebook(NotebookJson, Response) :-
    extract_notebook_data(NotebookJson, ID, Name, Type, NumPages, PageLength, _, _, CreatedAt, UpdatedAt),
    ( add_notebook_aux(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt)
    ->  current_notebook_id(CurrentID),
        format(atom(Message), 'Created notebook with ID ~w successfully.', [CurrentID]),
        Response = json{success: true, id: CurrentID, message: Message}
    ;   Response = json{success: false, message: 'Failed to create notebook.'}
    ).

add_notebook_aux(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt) :-
    next_notebook_id(ID),
    get_time(CurrentTime),
    format_time(atom(CreatedAt), '%d-%m-%Y %H:%M:%S', CurrentTime),
    UpdatedAt = CreatedAt,
    add_notebook(ID, Name, Type, NumPages, PageLength, CreatedAt, UpdatedAt).

delete_notebooks(ID, Name, Type, CreatedAt, UpdatedAt, _, _, _, PageLength, _, _, Response) :-
    delete_notebooks(ID, Name, Type, _, PageLength, CreatedAt, UpdatedAt),
    Response = json{success: true, message: 'Deleted notebook(s) successfully.'}.

delete_notebooks(_, _, _, _, _, _, _, _, _, _, _, Response) :-
    Response = json{success: false, errors: json{json: "No such notebook in database."}, message: 'Failed to delete notebook.'}.

update_notebook_handler(Request) :-
    memberchk(path_info(ID), Request), 
    http_read_json(Request, JSONData),
    atom_string(IDAtom, ID),  
    atom_number(IDAtom, IDNumber),  
    Type = JSONData.type,
    Name = JSONData.name,
    (   update_notebook(IDNumber, Type, Name)
    ->  Response = json{status: "success", message: "Notebook updated successfully."}
    ;   Response = json{status: "error", message: "Failed to update notebook."}
    ),
    reply_json(Response).