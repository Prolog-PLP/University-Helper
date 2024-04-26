:- consult('../../controllers/note_controller.pl').

extract_note_params(Request, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt) :-
    http_parameters(Request, [
        id(ID, [integer, optional(true)]),
        type(Type, [string, optional(true)]),
        visibility(Visibility, [string, optional(true)]),
        title(Title, [string, optional(true)]),
        subject(Subject, [string, optional(true)]),
        content(Content, [string, optional(true)]),
        creatorID(CreatorID, [integer, optional(true)]),
        createdAt(CreatedAt, [string, optional(true)]),
        updatedAt(UpdatedAt, [string, optional(true)])
    ]).

add_note_handler(Request) :-
    http_read_json_dict(Request, Note),
    add_note(Note, Response),
    reply_json(Response).

delete_notes_handler(Request) :-
    extract_note_params(Request, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    delete_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Response),
    reply_json(Response).

get_notes_handler(Request) :-
    extract_note_params(Request, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    get_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Notes),
    maplist(note_to_json, Notes, NotesJson),
    reply_json(json{notes: NotesJson}).

update_note_handler(ID, Request) :-
    % I think that'll need to change, 'cause it'll not be a number
    atom_number(ID, UID),
    http_read_json_dict(Request, Note),
    update_note(UID, Note, Response),
    reply_json(Response).
    