:- consult('../../database/users.pl').

get_users(ID, Name, Email, Password, UserType, CreatedAt) :-
    user(ID, Name, Email, Password, UserType, CreatedAt).

get_users(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt) :-
    user(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt).

get_user_by_id(ID, User) :-
    User = (get_users(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt) ;
            get_users(ID, Name, Email, Password, UserType, CreatedAt)).

add_user(ID, Name, Email, Password, Type, CreatedAt) :-
    assertz(user(ID, Name, Email, Password, Type, CreatedAt)),
    save_users('database/users.pl').

add_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    assertz(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)),
    save_users('database/users.pl').

update_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    retract(user(ID, _, _, _, _, _, _, _)),
    assertz(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)),
    save_users('database/users.pl').

delete_user(ID) :-
    retract(user(ID, _, _, _, _, _, _, _)),
    save_users('database/users.pl'). % Save changes back to the file

% Predicate to save user data back to the file
save_users(File) :-
    tell(File),
    listing(user),
    told.