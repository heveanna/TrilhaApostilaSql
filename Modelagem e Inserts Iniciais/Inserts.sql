/*
Documentacao:
Arquivo Fonte: Inserts.sql
Objetivo: Inserir agencias, clientes, contas e saldos iniciais
Autor: Yure
Data Criacao: 28/05/2026

Exemplo:
	Executar apos Modelagem.sql.
*/

USE RicBank2;
GO

BEGIN TRY

	BEGIN TRANSACTION

		INSERT INTO [dbo].[Agencia](Numero, Nome, DataCadastro)
			VALUES	(101, 'Agencia Centro', GETDATE()),
					(102, 'Agencia Bessa',	GETDATE());
		PRINT 'Agencias inseridas com sucesso'

		INSERT INTO [dbo].[Cliente](Nome, Email, CPF, DataNascimento, DataCadastro)
			VALUES	('Joao Silva',		'joao.silva@email.com',		12345678901, '1995-03-12', GETDATE()),
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

		INSERT INTO [dbo].[Saldo](IdConta, DataSaldo, SaldoInicial, Credito, Debito)
			VALUES	(1, GETDATE(), 0.00, 0.00, 0.00),
					(2, GETDATE(), 0.00, 0.00, 0.00),
					(3, GETDATE(), 0.00, 0.00, 0.00),
					(4, GETDATE(), 0.00, 0.00, 0.00),
					(5, GETDATE(), 0.00, 0.00, 0.00),
					(6, GETDATE(), 0.00, 0.00, 0.00),
					(7, GETDATE(), 0.00, 0.00, 0.00),
					(8, GETDATE(), 0.00, 0.00, 0.00);
		PRINT 'Saldos iniciais inseridos com sucesso'

		COMMIT TRANSACTION
		PRINT 'Inserts iniciais realizados com sucesso'

END TRY

BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION

	PRINT 'Ocorreu um erro ao executar os inserts iniciais'
	THROW
END CATCH
GO
