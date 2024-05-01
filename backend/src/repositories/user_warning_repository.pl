save_user_warnings :-
    database_path(BasePath),
    concat_paths(BasePath, 'user_warnings.pl', File),
    tell(File),
    listing(user_warning),
    told.

notify_user_repo(WarningID, WarnedUser) :-
    assertz(user_warning(WarningID, WarnedUser)),
    save_user_warnings.

get_user_warnings(WarningID, WarnedUser, UserWarnings) :-
    findall(
        user_warning(WarningID, WarnedUser),
        user_warning(WarningID, WarnedUser),
        UserWarnings
    ).

get_all_warnings_by_userId([], []).

get_all_warnings_by_userId([user_warning(ID, _)|Tail], [WarH|WarT]) :-
    get_note(ID, "Warning", _, _, _, _, _, _, _, WarH),
    get_all_warnings_by_userId(Tail, WarT).