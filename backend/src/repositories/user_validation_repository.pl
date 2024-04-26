:- consult('../utils.pl').
:- database_path(BasePath),
   concat_paths(BasePath, 'users_validation.pl', File),
   consult(File).

save_users_val :-
    database_path(BasePath),
    concat_paths(BasePath, 'users_validation.pl', File),
    tell(File),
    listing(user_val),
    listing(user_validation_id),
    listing(next_user_validation_id),
    told.

add_user_val(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    ( nonvar(Enrollment), nonvar(University)
    -> assertz(user_val(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt))
    ;  assertz(user_val(ID, Name, Email, Password, Type, CreatedAt))
    ),
    retract(user_validation_id(_)), 
    assertz(user_validation_id(ID)),
    save_users_val.

get_users_to_validate(Users) :-
    findall(
        user_val(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
        user_val(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
        Users8
    ),
    (   (var(University), var(Enrollment))
        ->  findall(
                user_val(ID, Name, Email, Password, Type, CreatedAt),
                user_val(ID, Name, Email, Password, Type, CreatedAt),
                Users6
            )
        ;   true
    ),
    append(Users6, Users8, Users).