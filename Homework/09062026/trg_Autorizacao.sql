USE RickBankPower;

IF EXISTS(SELECT 1 FROM [dbo].[sysobjects] 
			WHERE Id = OBJECT_Id(N'[dbo].[TRG_VerificarSaldo]') AND TYPE = 'TR')
	BEGIN 
		DROP TRIGGER [dbo].[TRG_VerificarSaldo]
	END

GO
CREATE TRIGGER [dbo].[TRG_VerificaeSaldo]
	ON [dbo].[Autorizacao]
	FOR INSERT, DELETE, UPDATE

	AS
	/*	Documentação

		Arquivo Fonte: TriggerAutorizacao.sql
		Objetivo: Fazer verificação do saldo e limite da conta
		Autor: Anna Hevellyn
		Data Criação: 02/06/2026
		Exemplo: BEGIN 
					IF EXISTS (SE)

	*/

