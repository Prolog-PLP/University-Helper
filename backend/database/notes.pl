
% TODO Implementar a lógica para cada ID e casar com seu respectivo tipo de anotação
:- dynamic current_note_id/1.

current_note_id(1).

next_note_id(A) :-
    current_note_id(B),
    A is B+1.