:- consult('../../controllers/user_controller.pl').


extract_user_params(Request, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    http_parameters(Request, [
        id(ID, [integer, optional(true)]),
        name(Name, [string, optional(true)]),
        email(Email, [string, optional(true)]),
        password(Password, [string, optional(true)]),
        type(Type, [string, optional(true), oneof(["student", "administrator", "professor"])]),
        enrollment(Enrollment, [string, optional(true)]),
        university(University, [string, optional(true)]),
        createdAt(CreatedAt, [string, optional(true)])
    ]).

user_exists_handler(Request) :-
    cors_enable(Request, [methods([get, options])]),
    extract_user_params(Request, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    get_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, _),
    reply_json(true), !.

user_exists_handler(_) :-
    reply_json(false).

add_user_handler(Request) :-
    cors_enable(Request, [methods([post, options])]),
    http_read_json_dict(Request, User),
    add_user(User, Response),
    reply_json(Response).

update_user_handler(ID, patch, Request) :-
    cors_enable(Request, [methods([patch, options])]),
    atom_number(ID, UID),
    http_read_json_dict(Request, User),
    update_user(UID, User, Response),
    reply_json(Response).

update_user_handler(_, options, Request) :-
    cors_enable(Request, [methods([patch, options])]),
    reply_json(true), !.

delete_users_handler(delete, Request) :-
    cors_enable(Request, [methods([options, delete])]),
    extract_user_params(Request, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    ((exists_val(ID)) 
    -> 
        remove_validation(ID)
    ;   true
    ),
    delete_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, Response),
    reply_json(Response).

delete_users_handler(options, Request) :-
    cors_enable(Request, [methods([options, delete])]),
    reply_json(true), !.

validate_user_handler(patch, ID, Request) :-
    cors_enable(Request, [methods([patch, options])]),
    atom_number(ID, UID),
    remove_validation(UID),
    reply_json(true).

validate_user_handler(options, _, Request) :-
    cors_enable(Request, [methods([patch, options])]), 
    reply_json(true), !.

unvalidate_user_handler(Request) :-
    cors_enable(Request, [methods([patch, options])]),
    extract_user_params(Request, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    remove_validation(ID),
    delete_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, Response),
    reply_json(Response).

get_users_handler(Request) :-
    cors_enable(Request, [methods([get, options])]),
    extract_user_params(Request, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    get_all_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, Users),
    maplist(user_to_json, Users, UsersJson),
    reply_json(json{users: UsersJson}).

get_validated_users_handler(Request) :-
    cors_enable(Request, [methods([get, options])]),
    get_validated_or_not_users(Users, true),
    maplist(user_to_json, Users, UsersJson),
    reply_json(json{users: UsersJson}).

get_unvalidated_users_handler(Request) :-
    cors_enable(Request, [methods([get, options])]),
    get_validated_or_not_users(Users, false),
    maplist(user_to_json, Users, UsersJson),
    reply_json(json{users: UsersJson}).

to_validate_users_handler(_) :-
    get_users_to_validate(Users),
    maplist(user_val_to_json, Users, UsersJson),
    reply_json(json{users: UsersJson}).
    