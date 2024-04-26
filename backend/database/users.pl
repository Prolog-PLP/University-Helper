:- dynamic user/6.

user(1, "Everton", "everton@admin.ufcg.edu.br", "senhasegura", "administrator", "19-04-2024 08:00:00").
user(2, "John", "john@example.com", "securepassword", "student", '26-04-2024 16:21:33').
user(3, "John", "rames@example.com", "securepassword", "professor", '26-04-2024 16:22:27').

:- dynamic user/8.

:- dynamic current_user_id/1.

current_user_id(3).

next_user_id(A) :-
    current_user_id(B),
    A is B+1.

