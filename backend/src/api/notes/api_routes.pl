:- consult('api_functions.pl').

http:location(notes, api(notes), []).

:- http_handler(notes(.), get_notes_handler, [method(options, get)]).
%  Fazer o match com o 'objeto' ou apenas o ID
:- http_handler(notes(delete), delete_notes_handler(Method), [method(Method), methods(options, delete)]).
:- http_handler(notes(add), add_note_handler(Method), [method(Method), methods(options, post)]).
:- http_handler(notes(getId/Type), get_note_id(Type, Method), [method(Method), methods(options, patch)]).
:- http_handler(notes(update), update_note_handler(Method), [method(Method), methods(options, post)]).
:- http_handler(notes(userNotifications), user_notifications_handler, [method(options, get)]).
:- http_handler(notes(notifyUser), notify_user_handler(Method), [method(Method), methods(options, post)]).