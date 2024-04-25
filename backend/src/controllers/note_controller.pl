:- consult('../repositories/note_repository.pl').

add_note(NoteJson, Response) :-
    extract_note_data(NoteJson, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    % place holder validate
    validate(Title, [has_alpha, has_alpha_or_ws_only], TitleErrors),
    create_json_from_list([title-TitleErrors], is_empty, Errors),
    create_json_from_list(is_empty, Errors),
    (   (is_empty(Errors), (\+ get_note(ID, _, _, _, _, _, _, _, _)))
    ->  
        add_note_aux(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
        % TODO
        current_note_id(CurrentID),
        format(atom(Message), 'Created note with ID ~w successfully.', [CurrentID]),
        Response = json{success: true, id: CurrentID, message: Message}
    ;
        Response = json{success: false, errors: Errors, message: 'Failed to create note.'}
    ).

add_note_aux(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt) :-
    next_note_id(ID),
    get_time(CurrentTime),
    format_time(atom(CreatedAt), '%d-%m-%Y %H:%M:%S', CurrentTime),
    add_note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt).

delete_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Response) :-
    delete_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    Response = json{success: true, message: 'Deleted note(s) successfully.'}.

delete_notes(_, _, _, _, _, _, _, _, _, Response) :-
    Response = json{success: false, errors: json{json: "No such user in database."}, message: 'Failed to delete note.'}.

update_note(ID, UpdatedNoteJson, Response) :-
    extract_note_data(UpdatedNoteJson, _, _, Visibility, Title, Subject, Content, _, _, _),
    update_note(ID, Type, Visibility, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    Response = json{success: true, message: 'Updated note(s) successfully.'}.

update_note(_, _, Response) :-
    Response = json{sucess: true, message: 'No note(s) were updated by this request'}.