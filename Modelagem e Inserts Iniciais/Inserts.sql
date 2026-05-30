USE RicBank2;
GO

BEGIN TRY

	BEGIN TRANSACTION
	
		INSERT INTO [dbo].[Agencia](Numero, Nome, DataCadastro)
			VALUES	(101, 'Agência Centro', GETDATE()),
					(102, 'Agência Bessa',	GETDATE());
		PRINT 'Agências inseridas com sucesso'

		INSERT INTO [dbo].[Cliente](Nome, Email, CPF, DataNascimento, DataCadastro)
			VALUES	('João Silva',		'joao.silva@email.com',		12345678901, '1995-03-12', GETDATE()),
					('Maria Oliveira',	'maria.oliveira@email.com', 23456789012, '1998-07-25', GETDATE()),
					('Carlos Souza',	'carlos.souza@email.com',	34567890123, '1989-11-08', GETDATE()),
					('Ana Pereira',		'ana.pereira@email.com',	45678901234, '2000-01-19', GETDATE()),
					('Lucas Ferreira',	'lucas.ferreira@email.com', 56789012345, '1993-09-30', GETDATE());
		PRINT 'Clientes inseridos com sucesso'

		INSERT INTO [dbo].[Conta](IdCliente, IdAgencia, Numero, DataCadastro)
			VALUES	(1, 1, 10001, GETDATE()),
					(1, 2, 10001, GETDATE()),
					(3, 1, 10002, GETDATE()),
					(3, 2, 10002, GETDATE()),
					(5, 1, 10003, GETDATE()),
					(5, 2, 10003, GETDATE()),
					(2, 1, 10004, GETDATE()),
					(4, 2, 10004, GETDATE());
		PRINT 'Contas inseridas com sucesso'

		INSERT INTO [dbo].[Saldo](IdConta, Credito, Debito, SaldoInicial, DataSaldo)
			VALUES	(1, 0.00, 0.00, 0.00, GETDATE()),
					(2, 0.00, 0.00, 0.00, GETDATE()),
					(3, 0.00, 0.00, 0.00, GETDATE()),
					(4, 0.00, 0.00, 0.00, GETDATE()),
					(5, 0.00, 0.00, 0.00, GETDATE()),
					(6, 0.00, 0.00, 0.00, GETDATE()),
					(7, 0.00, 0.00, 0.00, GETDATE()),
					(8, 0.00, 0.00, 0.00, GETDATE());
		PRINT 'Saldos iniciais inseridos com sucesso'

		COMMIT TRANSACTION
		PRINT 'Inserts iniciais realizados com sucesso'

	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Ocorreu um erro'
		END CATCH
GO
