:- dynamic notebook/3.
:- dynamic current_notebook_id/2.

current_notebook_id(convencional, 0).
current_notebook_id(cronologico, 0).
current_notebook_id(mental, 0).

next_notebook_id(Type, NextID) :-
    current_notebook_id(Type, CurrentID),
    NextID is CurrentID + 1.