USE RicBank2;
GO

INSERT INTO [dbo].[Agencia](Numero, Nome, DataCadastro)
	VALUES	(101, 'Agência Centro', GETDATE()),
			(102, 'Agência Bessa',	GETDATE());

SELECT *
	FROM [dbo].[Agencia] WITH(NOLOCK);

GO

INSERT INTO [dbo].[Cliente](Nome, Email, CPF, DataNascimento, DataCadastro)
	VALUES	('João Silva',		'joao.silva@email.com',		12345678901, '1995-03-12', GETDATE()),
			('Maria Oliveira',	'maria.oliveira@email.com', 23456789012, '1998-07-25', GETDATE()),
			('Carlos Souza',	'carlos.souza@email.com',	34567890123, '1989-11-08', GETDATE()),
			('Ana Pereira',		'ana.pereira@email.com',	45678901234, '2000-01-19', GETDATE()),
			('Lucas Ferreira',	'lucas.ferreira@email.com', 56789012345, '1993-09-30', GETDATE());

INSERT INTO [dbo].[Conta](IdCliente, IdAgencia, Numero, DataCadastro)
	VALUES	(1, 1, 10001, GETDATE()),
			(1, 2, 10001, GETDATE()),
			(3, 1, 10002, GETDATE()),
			(3, 2, 10002, GETDATE()),
			(5, 1, 10003, GETDATE()),
			(5, 2, 10003, GETDATE()),
			(2, 1, 10004, GETDATE()),
			(4, 2, 10004, GETDATE());
