:- consult('../../database/users.pl').

get_users(ID, Name, Email, Password, UserType, CreatedAt) :-
    user(ID, Name, Email, Password, UserType, CreatedAt).

get_users(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt) :-
    user(ID, Name, Email, Password, UserType, Enrollment, University, CreatedAt).