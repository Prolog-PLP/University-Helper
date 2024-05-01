:- dynamic note/9.

note(1, "Warning", "Private", "myWAR", "", "student", 1, '27-04-2024 19:39:43', "").
note(2, "Warning", "Private", "a", "", "a", 1, '30-04-2024 21:35:28', "").
note(3, "Warning", "Private", "s", "", "s", 1, '30-04-2024 21:37:08', "").
note(4, "Warning", "Private", "hello", "", "bye bye", 1, '01-05-2024 09:27:01', "").
note(5, "Warning", "Private", "bye bye", "", "dfadfa", 1, '01-05-2024 09:27:16', "").

:- dynamic current_note_id/2.

current_note_id(plt, 0).
current_note_id(rem, 0).
current_note_id(war, 5).

next_note_id(A, B) :-
    current_note_id(A, C),
    B is C+1.

