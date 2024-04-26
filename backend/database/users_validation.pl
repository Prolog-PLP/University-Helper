:- dynamic user_val/6.

user_val(2, "John", "james@example.com", "securepassword", "professor", '26-04-2024 15:28:25').

:- dynamic user_val/8.

user_val(3, "John", "roger@example.com", "securepassword", "professor", "1221111", "ufcg", '26-04-2024 15:29:45').

:- dynamic user_validation_id/1.

user_validation_id(3).

next_user_validation_id(A) :-
    user_validation_id(B),
    A is B+1.

