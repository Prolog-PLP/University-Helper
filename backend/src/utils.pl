:- use_module(library(date)).

user_to_json(user(ID, Name, Email, Password, Type, CreatedAt),
             json{id: ID, name: Name, email: Email, password: Password, type: Type, createdAt: CreatedAt}) :- !.

user_to_json(user(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt),
             json{id: ID, name: Name, email: Email, password: Password, type: Type, enrollment: Enrollment, university: University, createdAt: CreatedAt}).

note_to_json(note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
json{id: ID, type: Type, visibility:Visibility, title: Title, subject: Subject, content: Content, creatorID: CreatorID, createdAt: CreatedAt, updatedAt: UpdatedAt}).

user_warnings_to_json(user_warning(WarningID, WarnedUser),
json{warningID: WarningID, warnedUser: WarnedUser}).

database_path('backend/database/').

concat_paths(BasePath, PathToConcat, Result) :-
    concat_atom([BasePath, PathToConcat], Result).

is_empty([]).
is_empty(json{}).
is_empty('').
is_empty("").
is_empty(_-Value) :- 
    is_empty(Value).
all_empty([Head | Tail]) :- is_empty(Head), all_empty(Tail).

json_member(Json, Key, Value) :-
    ( get_dict(Key, Json, Value)
    -> true
    ; Value = _
    ).

create_json_from_list([], json{}).
create_json_from_list(Pairs, Json) :-
    dict_pairs(Json, json, Pairs).

create_json_from_list(Pairs, ExcludePredicate, Json) :-
    exclude(ExcludePredicate, Pairs, FilteredPairs),
    dict_pairs(Json, json, FilteredPairs).

validate(Value, Validations, Errors) :-
    maplist(apply_validation(Value), Validations, ErrorsList),
    flatten(ErrorsList, Errors).

apply_validation(Value, Validation, Error) :-
    call(Validation, Value, Result),
    (is_empty(Result)
    -> Error = []
    ;  Error = [Result]
    ).

len_not_greater_than(X, String, '') :-
    atom_length(String, Length),
    Length =< X, !.

len_not_greater_than(X, _, Failure) :-
    format(atom(Failure), 'The length is greater than ~w.', [X]).

len_not_less_than(X, String, '') :-
    atom_length(String, Length),
    Length >= X, !.

len_not_less_than(X, _, Failure) :-
    format(atom(Failure), 'The length is less than ~w.', [X]).

not_empty(X, '') :- (\+ is_empty(X)), !.
not_empty(_, 'Value is empty.').

has_alpha(String, '') :-
    atom_chars(String, Chars),
    member(Char, Chars),
    char_type(Char, alpha), !.

has_alpha(String, Failure) :-
    atom_chars(String, _),
    Failure = 'The string doesn\'t have any letters.'.

has_alpha_or_ws_only(String, '') :-
    atom_chars(String, Chars),
    has_alpha_or_ws_only_aux(Chars), !.

has_alpha_or_ws_only(_, 'The string has invalid characters.').

has_alpha_or_ws_only_aux([]).
has_alpha_or_ws_only_aux([Char|Chars]) :-
    (char_type(Char, alpha) ; char_type(Char, space)),
    has_alpha_or_ws_only_aux(Chars).

is_valid_email(Email, '') :-
    EmailPattern = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+(\\.[a-zA-Z]{2,})+$',
    re_match(EmailPattern, Email), !.

is_valid_email(_, 'Email is invalid!').

is_valid_user_type(Type, '') :-
    member(Type, ["student", "professor", "administrator"]), !.

is_valid_user_type(_, 'Type is invalid.').

email_is_available(Email, '') :-
    (\+ exists_user_with_email(Email)), !.

email_is_available(_, 'Email already exists!').

get_current_year(Year) :-
    get_time(Timestamp),
    stamp_date_time(Timestamp, DateTime, local),
    date_time_value(year, DateTime, Year).

extract_user_data(UserJson, ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    json_member(UserJson, id, ID),
    json_member(UserJson, name, Name),
    json_member(UserJson, email, Email),
    json_member(UserJson, password, Password),
    json_member(UserJson, type, Type),
    json_member(UserJson, enrollment, Enrollment),
    json_member(UserJson, university, University),
    json_member(UserJson, createdAt, CreatedAt).

extract_note_data(NoteJson, ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt) :-
    json_member(NoteJson, id, ID),
    json_member(NoteJson, type, Type),
    json_member(NoteJson, visibility, Visibility),
    json_member(NoteJson, title, Title),
    json_member(NoteJson, subject, Subject),
    json_member(NoteJson, content, Content),
    json_member(NoteJson, creatorID, CreatorID),
    json_member(NoteJson, createdAt, CreatedAt),
    json_member(NoteJson, updatedAt, UpdatedAt).

extract_notify_user_data(NotifyUserWarningJson, WarningID, WarnedUser) :-
    json_member(NotifyUserWarningJson, warningID, WarningID),
    json_member(NotifyUserWarningJson, warnedUser, WarnedUser).

extract_notebook_data(NotebookJson, ID, Type, Name) :-
    json_member(NotebookJson, id, ID),
    json_member(NotebookJson, type, Type),
    json_member(NotebookJson, name, Name).

unify_if_uninstantiated(PossiblyUninstantiatedVar, ValueToUnify) :-
    var(PossiblyUninstantiatedVar),
    PossiblyUninstantiatedVar = ValueToUnify, !.

unify_if_uninstantiated(_, _).