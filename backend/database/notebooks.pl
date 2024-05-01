:- dynamic notebook/5.

:- dynamic notebook/7.

:- dynamic current_notebook_id/1.

current_notebook_id(0).

next_notebook_id(A) :-
    current_notebook_id(B),
    A is B+1.

