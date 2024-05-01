:- dynamic notebook/5.

notebook(1, "MeuCaderno", "convencional", '01-05-2024 14:22:45', '01-05-2024 14:22:45').
notebook(2, "MeuCaderno", "convencional", '01-05-2024 14:23:12', '01-05-2024 14:23:12').
notebook(3, "MeuCaderno", "convencional", '01-05-2024 14:24:51', '01-05-2024 14:24:51').
notebook(4, "MeuCaderno", "convencional", '01-05-2024 14:28:39', '01-05-2024 14:28:39').
notebook(5, "MeuCaderno", "convencional", '01-05-2024 14:30:39', '01-05-2024 14:30:39').

:- dynamic notebook/7.

notebook(6, "MeuCaderno", "convencional", 30, 4, '01-05-2024 14:31:10', '01-05-2024 14:31:10').

:- dynamic current_notebook_id/1.

current_notebook_id(6).

next_notebook_id(A) :-
    current_notebook_id(B),
    A is B+1.

