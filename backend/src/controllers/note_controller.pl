:- consult('../repositories/note_repository.pl').

add_note(noteJson, Response) :-
    extract_note_data(noteJson, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    # validate(Name, [not_empty, has_alpha, has_alpha_or_ws_only], NameErrors),
    # validate(Email, [is_valid_email, email_is_available], EmailErrors),
    # validate(Password, [len_not_less_than(8)], PasswordErrors),
    # validate(Type, [is_valid_note_type], TypeErrors),
    # create_json_from_list([name-NameErrors, email-EmailErrors, password-PasswordErrors, type-TypeErrors], is_empty, Errors),
    create_json_from_list(is_empty, Errors),
    (   (is_empty(Errors), (\+ get_note(ID, _, _, _, _, _, _, _, _)))
    ->  
        add_note_aux(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
        current_note_id(CurrentID),
        format(atom(Message), 'Created note with ID ~w successfully.', [CurrentID]),
        Response = json{success: true, id: CurrentID, message: Message}
    ;
        Response = json{success: false, errors: Errors, message: 'Failed to create note.'}
    ).

add_note_aux(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    next_note_id(ID),
    get_time(CurrentTime),
    format_time(atom(CreatedAt), '%d-%m-%Y %H:%M:%S', CurrentTime),
    add_note(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt).