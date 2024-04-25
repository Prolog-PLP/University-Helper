:- consult('../../controllers/note_controller.pl').

add_note_handler(Request) :-
    http_read_json_dict(Request, Note),
    add_note(Note, Response),
    reply_json(Response).
