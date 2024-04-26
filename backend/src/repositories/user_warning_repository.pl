:- consult('../utils.pl').
:- database_path(BasePath),
   concat_paths(BasePath, 'user_warnings.pl', File),
   consult(File).

save_user_warnings :-
    database_path(BasePath),
    concat_paths(BasePath, 'user_warnings.pl', File),
    tell(File),
    listing(user_warnings),
    told.

notify_user_repo(WarningID, WarnedUser) :-
    assertz(user_warnings(WarningID, WarnedUser)),
    save_user_warnings.