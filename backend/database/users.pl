:- dynamic user/8. % user(ID, Name, Email, Password, Type, Enrollment, University, createdAt)
:- dynamic user/6. % user(ID, Name, Email, Password, Type, createdAt)
:- dynamic current_user_id/1. % current_user_id(ID)

user(1, 'Everton', 'everton@admin.ufcg.edu.br', 'senhasegura', administrador, '2024-04-19 08:00:00').

current_user_id(1).
next_user_id(ID) :-
    current_user_id(Current),
    ID is Current + 1.