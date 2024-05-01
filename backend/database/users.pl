:- dynamic user/6.

:- dynamic user/8.

user(4, "John", "roberto@example.com", "securepassword", "Professor", "122110748", "ufcg", '26-04-2024 16:22:27').

:- dynamic current_user_id/1.

current_user_id(7).

next_user_id(A) :-
    current_user_id(B),
    A is B+1.

