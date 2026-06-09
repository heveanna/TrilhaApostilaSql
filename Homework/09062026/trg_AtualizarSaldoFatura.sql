USE RicBank2;

DROP TRIGGER IF EXISTS [dbo].[AtualizarSaldoFatura];
GO

CREATE TRIGGER [dbo].[AtualizarSaldoFatura]
	ON [dbo].[Autorizacao]
	AFTER INSERT, DELETE, UPDATE
	AS
		/*	Documentação

			Arquivo fonte:	trg_AtualizarSaldoFatura.sql
			Objetivo:		Atualizar o saldo da fatura após a inserção, deleção ou atualização de um lançamento.
			Autor:			Djefferson dos Santos Lima
			Data Criação:	09/06/2026
			
		*/
	BEGIN
		[dbo].[Autorizador]

	END
		