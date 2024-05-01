:- dynamic note/9.

:- dynamic current_note_id/2.

current_note_id(plt, 0).
current_note_id(rem, 0).
current_note_id(war, 0).

next_note_id(A, B) :-
    current_note_id(A, C),
    B is C+1.