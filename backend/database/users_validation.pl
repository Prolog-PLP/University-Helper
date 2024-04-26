:- dynamic user_val/6.


:- dynamic user_val/8.


:- dynamic user_validation_id/1.

user_validation_id(1).

next_user_validation_id(A) :-
    user_validation_id(B),
    A is B+1.

