:- consult('../repositories/notebook_repository.pl').

%get_notebooks_handler(Request) :-
%    find_all_notebooks(Notebooks),
%    reply_json(json{notebooks: Notebooks}).

add_notebook(NotebookJson, Response) :-
    extract_notebook_data(NotebookJson, ID, Type, Name),
    add_notebook(ID, Type, Name),
    Response = json{success: true, message: 'Created Notebook(s) successfully.'}.

delete_notebook(ID, Type, Name, Response) :-
    delete_notebook(ID, Type, Name),
    Response = json{success: true, message: 'Deleted notebook(s) successfully.'}.

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
