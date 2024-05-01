:- consult('../repositories/note_repository.pl').

add_note(NoteJson, Response) :-
    extract_note_data(NoteJson, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    % place holder validate
    validate(Title, [], TitleErrors),
    create_json_from_list([title-TitleErrors], is_empty, Errors),
    (   (is_empty(Errors))
    ->  
        ((var(Subject) -> Subject = "" ; true)),
        ((var(UpdatedAt) -> UpdatedAt = "" ; true )),
        add_note_aux(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
        id_type(Type, IdType),
        current_note_id(IdType, CurrentID),
        format(atom(Message), 'Created note with ID ~w successfully.', [CurrentID]),
        Response = json{success: true, id: CurrentID, message: Message}
    ;
        Response = json{success: false, errors: Errors, message: 'Failed to create note.'}
    ).

id_type("Warning", war).
id_type("PlainText", plt).
id_type("Reminder", rem).
id_type(_, _).

get_id(Type, Response) :-
    next_note_id(Type, Response).

add_note_aux(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt) :-
    id_type(Type, IdType),
    next_note_id(IdType, ID),
    get_time(CurrentTime),
    format_time(atom(CreatedAt), '%d-%m-%Y %H:%M:%S', CurrentTime),
    UpdatedAt = CreatedAt,
    add_note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt).

delete_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Response) :-
    delete_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    Response = json{success: true, message: 'Deleted note(s) successfully.'}, !.

delete_notes(_, _, _, _, _, _, _, _, _, Response) :-
    Response = json{success: false, errors: json{json: "No such note in database."}, message: 'Failed to delete note.'}.

update_note(ID, UpdatedNoteJson, Response) :-
    extract_note_data(UpdatedNoteJson, _, Type, Visibility, Title, Subject, Content, _, _, _),
    get_time(CurrentTime),
    format_time(atom(UpdatedAt), '%d-%m-%Y %H:%M:%S', CurrentTime),
    update_note(ID, Type, Visibility, Title, Subject, Content, _, _, UpdatedAt),
    Response = json{success: true, message: 'Updated note(s) successfully.'}, !.

update_note(_, _, Response) :-
    Response = json{sucess: true, message: 'No note(s) were updated by this request'}.
