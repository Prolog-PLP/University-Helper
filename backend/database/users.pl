:- dynamic user/8. % user(ID, Name, Email, Password, Type, Enrollment, University, createdAt)
:- dynamic user/6. % user(ID, Name, Email, Password, Type, createdAt)

% Initial users
user(1, 'Everton', 'everton@admin.ufcg.edu.br', 'senhasegura', administrador, '2024-04-19 08:00:00').