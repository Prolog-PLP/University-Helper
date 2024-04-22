:- consult('../../controllers/user_controller.pl').
:- debug(get_users_handler).

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
    extract_user_params(Request, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    get_user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    reply_json(true), !.

user_exists_handler(_) :-
    reply_json(false).

add_user_handler(Request) :-
    http_read_json_dict(Request, User),
    add_user(User, Response),
    reply_json(Response).

update_user_handler(Request) :-
    http_read_json_dict(Request, User),
    update_user(User),
    reply_json(json{success: true}).

delete_users_handler(Request) :-
    http_read_json_dict(Request, User),
    delete_users(User, Response),
    reply_json(Response).

get_users_handler(Request) :-
    extract_user_params(Request, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
    get_users(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt, Users),
    maplist(user_to_json, Users, UsersJson),
    reply_json(json{users: UsersJson}).