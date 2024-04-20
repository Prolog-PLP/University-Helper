:- consult('../repositories/user_repository.pl').

get_users(ID, Name, Email, Password, UserType, CreatedAt) :-
    user(ID, Name, Email, Password, UserType, CreatedAt).

get_users(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt) :-
    user(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt).

get_user_by_id(ID, User) :-
    User = (get_users(ID, _, _, _, _, _, _, _) ;
            get_users(ID, _, _, _, _, _)).

add_user(json{name: Name, email: Email, password: Password, type: Type}) :-
    next_user_id(ID),
    get_time(CurrentTime),
    format_time(atom(CreatedAt), '%d-%m-%Y %H:%M:%S', CurrentTime),
    add_user(ID, Name, Email, Password, Type, CreatedAt).

add_user(json{id: ID, name: Name, email: Email, password: Password, type: Type, createdAt: CreatedAt}) :-
    next_user_id(NextID),
    ID =:= NextID,
    parse_time('%d-%m-%Y %H:%M:%S', CreatedAt, _),
    add_user(ID, Name, Email, Password, Type, CreatedAt).

add_user(ID, Name, Email, Password, Type, CreatedAt) :-
    assertz(user(ID, Name, Email, Password, Type, CreatedAt)),
    retract(current_user_id(_)), 
    assertz(current_user_id(ID)),
    save_users.

add_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    assertz(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)),
    retract(current_id(_)), 
    assertz(current_id(ID)),
    save_users.

update_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    retract(user(ID, _, _, _, _, _, _, _)),
    assertz(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)),
    save_users.

delete_user(ID) :-
    retract(user(ID, _, _, _, _, _, _, _)),
    save_users.