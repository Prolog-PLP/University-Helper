:- dynamic page/3.

current_page_id(0).

next_page_id(NextId) :-
    current_page_id(Current),
    NextId is Current+1.