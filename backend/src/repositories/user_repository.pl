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
    ( nonvar(Enrollment), nonvar(University)
    -> assertz(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt))
    ;  assertz(user(ID, Name, Email, Password, Type, CreatedAt))
    ),
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
        (   user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)
        ->  User = user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)
        ;   user(ID, Name, Email, Password, Type, CreatedAt),
            User = user(ID, Name, Email, Password, Type, CreatedAt)
        ).

get_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, Users) :-
    findall(
        user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
        user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
        Users8
    ),
    (   (var(University), var(Enrollment))
    ->  findall(
            user(ID, Name, Email, Password, Type, CreatedAt),
            user(ID, Name, Email, Password, Type, CreatedAt),
            Users6
        )
    ;   true
    ),
    append(Users6, Users8, Users).

exists_user_with_email(Email) :-
    get_user(_, _, Email, _, _, _, _, _, _).