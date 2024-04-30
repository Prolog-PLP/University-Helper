:- dynamic user/6.

user(1, "Everton", "everton@admin.ufcg.edu.br", "senhasegura", "administrator", "19-04-2024 08:00:00").
user(2, "John", "john@example.com", "securepassword", "student", '26-04-2024 16:21:33').
user(3, "John", "rames@example.com", "securepassword", "professor", '26-04-2024 16:22:27').
user(5, "Roberto", "robertoTheMan@example.com", "secure12345", "student", '26-04-2024 21:54:03').
user(6, "theProfessor", "JohnJohn@example.com", "secure12345", "professor", '26-04-2024 21:54:36').

:- dynamic user/8.

user(4, "John", "roberto@example.com", "securepassword", "professor", "122110748", "ufcg", '26-04-2024 16:22:27').


:- dynamic current_user_id/1.

current_user_id(6).

next_user_id(A) :-
    current_user_id(B),
    A is B+1.

