:- consult('../repositories/notebook_repository.pl').

add_notebook_handler(Request) :-
    http_read_json(Request, JsonData),
    extract_notebook_data(JsonData, ID, Type, Name),
    add_notebook(ID, Type, Name, Response),
    reply_json(Response).

delete_notebook(ID, Type, Name, Response) :-
    delete_notebook(ID, Type, Name),
    Response = json{success: true, message: 'Deleted notebook(s) successfully.'}.

update_notebook_handler(Request) :-
    http_parameters(Request, [id(ID, [])]),
    http_read_json(Request, UpdatedNotebookJson),
    extract_notebook_data(UpdatedNotebookJson, _, Type, Name),
    (   update_notebook(ID, Type, Name)
    ->  Response = json{success: true, message: 'Updated notebook successfully.'}
    ;   Response = json{success: false, message: 'Failed to update notebook.'}
    ),
    reply_json(Response).

    extract_notebook_data(Json, ID, Type, Name) :-
        % Supondo que o JSON seja uma estrutura json{...}
        Json = json{id: ID, type: Type, name: Name}.