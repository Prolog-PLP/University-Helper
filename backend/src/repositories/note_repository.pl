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


% Reminder
% Warning
% Text
% Tamo aqui
get_note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Note) :-
        (   note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt)
        ->  Note = note(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)
        ;   user(ID, Name, Email, Password, Type, CreatedAt),
            Note = note(ID, Name, Email, Password, Type, CreatedAt)
        ).