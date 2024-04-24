:- consult('../utils.pl').
:- database_path(BasePath),
   concat_paths(BasePath, 'users.pl', File),
   consult(File).

save_users :-
    database_path(BasePath),
    concat_paths(BasePath, 'users.pl', File),
    tell(File),
    listing(user),
    listing(current_user_id),
    listing(next_user_id),
    told.

add_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    ( (\+ (Enrollment = _ ; University = _))
    -> assertz(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt))
    ;  assertz(user(ID, Name, Email, Password, Type, CreatedAt))),
    retract(current_user_id(_)), 
    assertz(current_user_id(ID)),
    save_users.

update_user(ID, Name, Email, Password, Type, Enrollment, University) :-
    retract(user(ID, OldName, OldEmail, OldPassword, OldType, OldEnrollment, OldUniversity, OldCreatedAt)),
    maplist(unify_if_uninstantiated,
            [Name, Email, Password, Type, Enrollment, University],
            [OldName, OldEmail, OldPassword, OldType, OldEnrollment, OldUniversity]),
    assertz(user(ID, Name, Email, Password, Type, Enrollment, University, OldCreatedAt)),
    save_users, !.

update_user(ID, Name, Email, Password, Type, _, _) :-
    retract(user(ID, OldName, OldEmail, OldPassword, OldType, OldCreatedAt)),
    maplist(unify_if_uninstantiated,
            [Name, Email, Password, Type],
            [OldName, OldEmail, OldPassword, OldType]),
    assertz(user(ID, Name, Email, Password, Type, OldCreatedAt)),
    save_users.

delete_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    retractall(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)),
    retractall(user(ID, Name, Email, Password, Type, CreatedAt)),
    save_users.

get_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, User) :-
        user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
        User = user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt), !.

get_user(ID, Name, Email, Password, Type, _, _, CreatedAt, User) :-
        user(ID, Name, Email, Password, Type, CreatedAt),
        User = user(ID, Name, Email, Password, Type, CreatedAt).

get_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, Users) :-
    findall(
        User,
        get_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, User),
        Users
    ).

exists_user_with_email(Email) :-
    get_user(_, _, Email, _, _, _, _, _, _).