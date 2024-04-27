:- consult('../utils.pl').
:- database_path(BasePath),
   concat_paths(BasePath, 'notes.pl', File),
   consult(File).

save_notes :-
    database_path(BasePath),
    concat_paths(BasePath, 'notes.pl', File),
    tell(File),
    listing(note),
    listing(current_note_id),
    listing(next_note_id),
    told.

add_note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt) :-
    assertz(note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt)),
    id_type(Type, IdType),
    retract(current_note_id(IdType, _)), 
    assertz(current_note_id(IdType, ID)),
    save_notes.

delete_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt) :-
    retractall(note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt)),
    save_notes.

get_note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Note) :-
        (   note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt)
        ->  Note = note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt)
        ).

get_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Notes) :-
    findall(
        note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
        note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
        Notes
    ).

update_note(ID, Type, Visibility, Title, Subject, Content, _, _, UpdatedAt) :-
    retract(note(ID, Type, OldVisibility, OldTitle, OldSubject, OldContent, OldCreatorID, OldCreatedAt, OldUpdatedAt)),
    maplist(unify_if_uninstantiated, [Visibility, Title, Subject, Content, UpdatedAt], 
                                    [OldVisibility, OldTitle, OldSubject, OldContent, OldUpdatedAt]),
    assertz(note(ID, Type, Visibility, Title, Subject, Content, OldCreatorID, OldCreatedAt, UpdatedAt)),
    save_notes.