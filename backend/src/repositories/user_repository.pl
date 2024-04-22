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

delete_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    retractall(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)),
    retractall(user(ID, Name, Email, Password, Type, CreatedAt)),
    save_users.

get_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, User) :-
        user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
        User = user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt).

get_user(ID, Name, Email, Password, Type, _, _, CreatedAt, User) :-
        user(ID, Name, Email, Password, Type, CreatedAt),
        User = user(ID, Name, Email, Password, Type, CreatedAt).

exists_user_with_email(Email) :-
    get_user(_, _, Email, _, _, _, _, _, _).