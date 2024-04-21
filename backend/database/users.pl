:- dynamic user/6.

user(1, "Everton", "everton@admin.ufcg.edu.br", "senhasegura", "administrator", "19-04-2024 08:00:00").

:- dynamic user/8.


:- dynamic current_user_id/1.

current_user_id(1).

next_user_id(A) :-
    current_user_id(B),
    A is B+1.

