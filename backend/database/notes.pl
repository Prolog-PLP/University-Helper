:- dynamic note/9.

note(1, "Warning", "private", "myWAR", _, "student", 1, '27-04-2024 19:39:43', _).

:- dynamic current_note_id/2.

current_note_id(plt, 0).
current_note_id(rem, 0).
current_note_id(war, 1).

next_note_id(A, B) :-
    current_note_id(A, C),
    B is C+1.

