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

extract_user_warning_params(Request, WarningID, WarnedUser) :-
    http_parameters(Request, [
        warningID(WarningID, [integer, optional(true)]),
        warnedUser(WarnedUser, [integer, optional(true)])
    ]).

add_note_handler(Request) :-
    cors_enable(Request, [methods([add, options])]),
    http_read_json_dict(Request, Note),
    add_note(Note, Response),
    reply_json(Response).

delete_notes_handler(Request) :-
    cors_enable(Request, [methods([delete, options])]),
    extract_note_params(Request, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    delete_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Response),
    reply_json(Response).

get_notes_handler(Request) :-
    cors_enable(Request, [methods([get, options])]),
    extract_note_params(Request, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
    get_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Notes),
    maplist(note_to_json, Notes, NotesJson),
    reply_json(json{notes: NotesJson}).

update_note_handler(ID, Request) :-
    % I think that'll need to change, 'cause it'll not be a number
    cors_enable(Request, [methods([get, post])]),
    atom_number(ID, UID),
    http_read_json_dict(Request, Note),
    update_note(UID, Note, Response),
    reply_json(Response).
    
notify_user_handler(Request) :-
    cors_enable(Request, [methods([post, options])]),
    http_read_json_dict(Request, NotifyUserWarning),
    notify_user(NotifyUserWarning, Response),
    reply_json(Response).

user_notifications_handler(Request) :-
    cors_enable(Request, [methods([get, options])]),
    extract_user_warning_params(Request, WarningID, WarnedUser),
    get_user_warnings(WarningID, WarnedUser, UserWarnings),
    maplist(user_warnings_to_json, UserWarnings, UserWarningsJson),
    reply_json(json{user_warnings: UserWarningsJson}).
