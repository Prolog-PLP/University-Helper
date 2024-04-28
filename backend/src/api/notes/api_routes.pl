:- consult('api_functions.pl').

http:location(notes, api(notes), []).

:- http_handler(notes(.), get_notes_handler, [method(options, get)]).
%  Fazer o match com o 'objeto' ou apenas o ID
:- http_handler(notes(delete), delete_notes_handler, [method(options, delete)]).
:- http_handler(notes(add), add_note_handler, [method(optons, post)]).
:- http_handler(notes(update), update_notes_handler, [method(options, post)]).
:- http_handler(notes(userNotifications), user_notifications_handler, [method(options, get)]).
:- http_handler(notes(notifyUser), notify_user_handler, [method(options, post)]).