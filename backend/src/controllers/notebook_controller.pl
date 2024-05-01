:- consult('../repositories/notebook_repository.pl').

add_notebook(NotebookJson, Result) :-
    extract_notebook_data(NotebookJson, ID, Type, Name, ExtraData),
    (   Type = 'conventional'
    ->  add_conventional_notebook(ID, Name, ExtraData, Result)
    ;   Type = 'chronological'
    ->  add_chronological_notebook(ID, Name, ExtraData, Result)
    ;   Type = 'mental'
    ->  add_mental_notebook(ID, Name, ExtraData, Result)
    ;   Result = {response: json{success: false, message: 'Invalid notebook type'}}
    ).

add_conventional_notebook(ID, Name, SubjectsPages, Result) :-
    assertz(notebook(ID, Name, SubjectsPages)),
    save_notebooks,
    Result = {response: json{success: true, message: 'Created Conventional Notebook successfully.'}, id: ID, name: Name, subjectsPages: SubjectsPages}.
        
add_chronological_notebook(ID, Name, HasPages, Result) :-
    assertz(chronological_notebook(ID, Name, HasPages)),
    save_notebooks,
    Result = {response: json{success: true, message: 'Created Chronological Notebook successfully.'}, id: ID, name: Name, hasPages: HasPages}.
        
add_mental_notebook(ID, Name, Keywords, Result) :-
    assertz(mental_notebook(ID, Name, Keywords)),
    save_notebooks,
    Result = {response: json{success: true, message: 'Created Mental Notebook successfully.'}, id: ID, name: Name, keywords: Keywords}.

delete_notebook_handler(Request) :-
    extract_notebook_params(Request, ID, Type, _),
    (   Type = 'chronological'
    ->  Response = json{success: false, message: 'Cannot delete notes from a Chronological Notebook.'}
    ;   delete_notebook(ID, Type, _),
        Response = json{success: true, message: 'Notebook deleted successfully.'}
    ),
    reply_json(Response).

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