:- consult('api_functions.pl').

http:location(notes, api(notes), []).

:- http_handler(notes(.), get_notes_handler, [method(get)]).
%  Fazer o match com o 'objeto' ou apenas o ID
:- http_handler(notes(delete), delete_notes_handler, [method(delete)]).
:- http_handler(notes(add), add_note_handler, [method(post)]).
:- http_handler(notes(update), update_notes_handler, [method(post)]).
:- http_handler(notes(getId), get_note_id_handler, [method(post)]).
:- http_handler(notes(notifyUser), notify_user_handler, [method(post)]).
:- http_handler(notes(userNotifications), user_notifications_handler, [method(get)]).