user_to_json(user(ID, Name, Email, Password, Type, Enrollment),
             json{id: ID, name: Name, email: Email, password: Password, type: Type, enrollment: Enrollment}).

database_path('backend/database/').

concat_paths(BasePath, PathToConcat, Result) :-
    concat_atom([BasePath, PathToConcat], Result).