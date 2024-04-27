:- consult('../repositories/notebook_repository.pl').:- consult('../repositories/notebook_repository.pl').

add_notebook(NotebookJson, Response) :-
    extract_notebook_data(NotebookJson, ID, Type, Name),
    % Placeholder to validate:
    validate(Name, [has_alpha, has_alpha_or_ws_only], NameErrors),
    create_json_from_list([name-NameErrors], Errors),
    (   is_empty(Errors), \+ get_notebook(ID, _, _)
    ->  add_notebook_aux(ID, Type, Name),
        current_notebook_id(CurrentID),
        format(atom(Message), 'Created notebook with ID ~w successfully.', [CurrentID]),
        Response = json{success: true, id: CurrentID, message: Message}
    ;   Response = json{success: false, errors: Errors, message: 'Failed to create notebook.'}
    ).

delete_notebook(ID, Type, Name, Response) :-
    delete_notebook(ID, Type, Name),
    Response = json{success: true, message: 'Deleted notebook(s) successfully.'}.

update_notebook(ID, UpdatedNotebookJson, Response) :-
    extract_notebook_data(UpdatedNotebookJson, _, Type, Name),
    update_notebook(ID, Type, Name),
    Response = json{success: true, message: 'Updated notebook successfully.'}.
