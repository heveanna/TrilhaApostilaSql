<<<<<<< HEAD
USE RicBank2;

DROP TRIGGER IF EXISTS [dbo].[trg_AutorizarAutorizacao];
GO

CREATE TRIGGER  [dbo].[trg_AutorizarAutorizacao]
	ON [dbo].[Autorizacao]
	AFTER INSERT
	AS
		/*	Documentação

			Arquivo fonte:	trg_AtualizarSaldoFatura.sql
			Objetivo:		Chamar a procedure [dbo].[sp_Autorizador] para verificar se uma nova instância na tabela
							[dbo].[Autorizacao] cumpri os requisitos para ser validada. 
			Autor:			Djefferson dos Santos Lima
			Data Criação:	09/06/2026
			
		*/
	BEGIN

		DECLARE @IdNovaAutorizacao INT = ( SELECT Id FROM inserted );

		EXEC [dbo].[sp_Autorizador]	@IdAutorizacao = @IdNovaAutorizacao;

	END
GO
=======
USE RicBank2;

DROP TRIGGER IF EXISTS [dbo].[trg_AutorizarAutorizacao];
GO

CREATE TRIGGER  [dbo].[trg_AutorizarAutorizacao]
	ON [dbo].[Autorizacao]
	AFTER INSERT
	AS
		/*	Documentação

			Arquivo fonte:	trg_AtualizarSaldoFatura.sql
			Objetivo:		Chamar a procedure [dbo].[sp_Autorizador] para verificar se uma nova instância na tabela
							[dbo].[Autorizacao] cumpri os requisitos para ser validada. 
			Autor:			Djefferson dos Santos Lima
			Data Criação:	09/06/2026
			
		*/
	BEGIN

		DECLARE @IdNovaAutorizacao INT = ( SELECT Id FROM inserted );

		EXEC [dbo].[sp_Autorizador]	@IdAutorizacao = @IdNovaAutorizacao;

	END
GO
>>>>>>> edf2b5a446b3355c0affd37b843f11140244e1ec
		