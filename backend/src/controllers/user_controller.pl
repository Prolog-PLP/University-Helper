:- consult('../repositories/user_repository.pl').

get_users(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt, Users) :-
    findall(
        user(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt),
        (user(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt) ; 
         user(ID, Name, Email, Password, UserType, CreatedAt)),
        Users
    ).

get_user(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt) :-
        (user(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt)) ; 
        (user(ID, Name, Email, Password, UserType, CreatedAt)).

add_user(UserJson, Response) :-
    json_member(UserJson, name, Name),
    json_member(UserJson, email, Email),
    json_member(UserJson, password, Password),
    json_member(UserJson, type, Type),
    validate(Name, [not_empty, has_alpha, has_alpha_or_ws_only], NameErrors),
    validate(Email, [is_valid_email, email_is_available], EmailErrors),
    validate(Password, [len_not_less_than(8)], PasswordErrors),
    validate(Type, [is_valid_user_type], TypeErrors),
    create_json_from_list([name-NameErrors, email-EmailErrors, password-PasswordErrors, type-TypeErrors], is_empty, Errors),
    (   (is_empty(Errors), (\+ get_user(_, _, Email, _, _, _, _, _, _)))
    ->  
        add_user_aux(UserJson),
        current_user_id(CurrentID),
        format(atom(Message), 'Created user with ID ~w successfully.', [CurrentID]),
        Response = json{success: true, id: CurrentID, message: Message}
    ;
        Response = json{success: false, errors: Errors, message: 'Failed to create user.'}
    ).

add_user_aux(json{name: Name, email: Email, password: Password, type: Type}) :-
    next_user_id(ID),
    get_time(CurrentTime),
    format_time(atom(CreatedAt), '%d-%m-%Y %H:%M:%S', CurrentTime),
    add_user(ID, Name, Email, Password, Type, CreatedAt).

add_user_aux(json{id: ID, name: Name, email: Email, password: Password, type: Type, createdAt: CreatedAt}) :-
    next_user_id(NextID),
    ID =:= NextID,
    add_user(ID, Name, Email, Password, Type, CreatedAt).

update_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    retract(user(ID, _, _, _, _, _, _, _)),
    assertz(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)),
    save_users.

delete_user(ID) :-
    retract(user(ID, _, _, _, _, _, _, _)),
    save_users.