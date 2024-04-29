:- dynamic notebook/3.

notebook("3", "teste", "joao").
notebook("4", "teste", "jfsdoao").

:- dynamic current_notebook_id/2.

current_notebook_id(convencional, 0).
current_notebook_id(cronologico, 0).
current_notebook_id(mental, 0).

next_notebook_id(A, B) :-
    current_notebook_id(A, C),
    B is C+1.

