:- dynamic note/9.

%note(1, "Warning", "public", "Titulo Atenção", "Assunto Preste Atenção!", "Conteudo Mais Atenção", 1, "19-04-2024 08:00:00", "19-04-2024 08:00:00").

:- dynamic current_id/2.

current_note_id(rem, 1).
current_note_id(plt, 1).
current_note_id(war, 1).

next_note_id(C, A) :-
    current_note_id(C, B),
    A is B + 1.