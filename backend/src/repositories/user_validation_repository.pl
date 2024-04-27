:- consult('../utils.pl').
:- database_path(BasePath),
   concat_paths(BasePath, 'users_validation.pl', File),
   consult(File).

save_users_val :-
    database_path(BasePath),
    concat_paths(BasePath, 'users_validation.pl', File),
    tell(File),
    listing(user_val),
    told.

add_user_val(ID) :-
    assertz(user_val(ID)),
    save_users_val.

get_ids_to_validate(IdsValidation) :-
    findall(
        ID,
        user_val(ID),
        IdsValidation
    ).

remove_validation(ID) :-
    retract(user_val(ID)),
    save_users_val.