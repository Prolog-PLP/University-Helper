:- consult('../repositories/user_repository.pl').
:- consult('../repositories/user_validation_repository.pl').
:- consult('../repositories/user_warning_repository.pl').

add_user(UserJson, Response) :-
    extract_user_data(UserJson, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    validate(Name, [not_empty, has_alpha, has_alpha_or_ws_only], NameErrors),
    validate(Email, [is_valid_email, email_is_available], EmailErrors),
    validate(Password, [len_not_less_than(8)], PasswordErrors),
    validate(Type, [is_valid_user_type], TypeErrors),
    create_json_from_list([name-NameErrors, email-EmailErrors, password-PasswordErrors, type-TypeErrors], is_empty, Errors),
    
    ( (is_empty(Errors), (\+ get_user(_, _, Email, _, _, _, _, _, _)))
    ->  ((Type = "Professor") 
        ->  add_user_val_aux(ID)
        ; true
        ),
        add_user_aux(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
        current_user_id(CurrentID),
        format(atom(Message), 'Created user with ID ~w successfully.', [CurrentID]),
        Response = json{success: true, id: CurrentID, message: Message} 
    ;
        Response = json{success: false, errors: Errors, message: 'Failed to create user.'}
    ).

add_user_val_aux(ID) :-
    next_user_id(ID),
    add_user_val(ID).

add_user_aux(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    next_user_id(ID),
    get_time(CurrentTime),
    format_time(atom(CreatedAt), '%d-%m-%Y %H:%M:%S', CurrentTime),
    add_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt).

update_user(ID, UpdatedUserJson, Response) :-
    extract_user_data(UpdatedUserJson, _, Name, Email, Password, Type, Enrollment, University, _),
    update_user(ID, Name, Email, Password, Type, Enrollment, University),
    Response = json{success: true, message: 'Updated user(s) successfully.'}, !.

update_user(_, _, Response) :-
    Response = json{success: true, message: 'No user(s) were updated by this request.'}.

delete_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, Response) :-
    delete_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    Response = json{success: true, message: 'Deleted user(s) successfully.'}, !.

delete_users(_, _, _, _, _, _, _, _, Response) :-
    Response = json{success: false, errors: json{json: "No such user in database."}, message: 'Failed to delete user.'}.

notify_user_aux(WarningID, WarnedUser) :-
    notify_user_repo(WarningID, WarnedUser).

notify_user(NotifyUserWarningJson, Response) :-
    extract_notify_user_data(NotifyUserWarningJson, WarningID, WarnedUser),
    % place holder validate
    validate(WarnedUser, [], WarnedUserErrors),
    create_json_from_list([warnedUser-WarnedUserErrors], is_empty, Errors),
    (   (is_empty(Errors))
    ->  
        notify_user_aux(WarningID, WarnedUser),
        format(atom(Message), 'User with ID ~w notified successfully.', [WarnedUser]),
        Response = json{success: true, warnedUser: WarnedUser, warningID: WarningID, message: Message}
    ;
        Response = json{success: false, errors: Errors, message: 'Failed to create note.'}
    ).