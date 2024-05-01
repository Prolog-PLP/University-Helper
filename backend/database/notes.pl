:- dynamic note/9.

note(1, "Warning", "Private", "myWAR", _, "student", 1, '27-04-2024 19:39:43', _).
note(2, "Warning", "Private", "a", "", "a", 1, '30-04-2024 21:35:28', _).
note(3, "Warning", "Private", "s", "", "s", 1, '30-04-2024 21:37:08', _).

:- dynamic current_note_id/2.

current_note_id(plt, 0).
current_note_id(rem, 0).
current_note_id(war, 3).

next_note_id(A, B) :-
    current_note_id(A, C),
    B is C+1.

