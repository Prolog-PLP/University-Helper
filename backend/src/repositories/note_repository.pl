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
    retract(current_note_id(_)), 
    assertz(current_note_id(ID)),
    save_notes.

delete_notes(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt) :-
    retractall(note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt)),
    save_notes.


% Reminder
% Warning
% Text
% Tamo aqui
get_note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Note) :-
        (   note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt)
        ->  Note = note(ID, Name, Email, Password, Type, Enrollment, University, CreatedAt)
        ).

get_notes(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt, Notes) :-
    findall(
        note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
        note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt),
        Notes
    ).

update_note(ID, Type, Visibility, Title, Subject, Content, CreatorID, CreatedAt, UpdatedAt) :-
    retract(note(ID, OldType, OldVisibility, OldTitle, OldSubject, OldContent, OldCreatorID, OldCreatedAt, OldUpdatedAt)),
    maplist(unify_if_uninstantiated, [Visibility, Title, Subject, Content], 
                                    [OldVisibility, OldTitle, OldSubject, OldContent]),
    assertz(note(ID, OldType, Visibility, Title, Subject, Content, OldCreatorID, OldCreatedAt, OldUpdatedAt)),
    save_notes.