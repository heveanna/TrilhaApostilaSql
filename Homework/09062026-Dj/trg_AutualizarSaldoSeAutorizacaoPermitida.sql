<<<<<<< HEAD
USE RicBank2;

DROP TRIGGER IF EXISTS [dbo].[trg_AutualizarSaldoSeAutorizacaoPermitida];
GO

CREATE TRIGGER [dbo].[trg_AutualizarSaldoSeAutorizacaoPermitida]
	ON [dbo].[Autorizacao]
	AFTER UPDATE, DELETE
	AS
		/*	Documentação
			
			Arquivo fonte: trg_AutualizarSaldoSeAutorizacaoPermitida.sql
			Objetivo:	Quando uma autorizacao for verificada ou deleteda, atualizar o saldo de acordo com as regras de
						negócio.
			Autor: Djefferson dos Santos Lima
			Data criação: 10/06/2026

		*/
		BEGIN
			IF EXISTS ( SELECT 1 FROM deleted WHERE Autorizado = 1 )
				BEGIN
					UPDATE [dbo].[Fatura] 
						SET Saldo = (fa.Saldo - d.Valor)
						FROM [dbo].[Fatura] as fa
							INNER JOIN deleted d
								ON fa.Id = d.IdFatura
									AND d.Autorizado = 1
				END

			IF EXISTS ( SELECT 1 FROM inserted WHERE Autorizado = 1 )
				BEGIN
					UPDATE [dbo].[Fatura] 
						SET Saldo = (fa.Saldo + i.Valor)
						FROM [dbo].[Fatura] as fa
							INNER JOIN inserted i
								ON fa.Id = i.IdFatura
				END
=======
USE RicBank2;

DROP TRIGGER IF EXISTS [dbo].[trg_AutualizarSaldoSeAutorizacaoPermitida];
GO

CREATE TRIGGER [dbo].[trg_AutualizarSaldoSeAutorizacaoPermitida]
	ON [dbo].[Autorizacao]
	AFTER UPDATE, DELETE
	AS
		/*	Documentação
			
			Arquivo fonte: trg_AutualizarSaldoSeAutorizacaoPermitida.sql
			Objetivo:	Quando uma autorizacao for verificada ou deleteda, atualizar o saldo de acordo com as regras de
						negócio.
			Autor: Djefferson dos Santos Lima
			Data criação: 10/06/2026

		*/
		BEGIN
			IF EXISTS ( SELECT 1 FROM deleted WHERE Autorizado = 1 )
				BEGIN
					UPDATE [dbo].[Fatura] 
						SET Saldo = (fa.Saldo - d.Valor)
						FROM [dbo].[Fatura] as fa
							INNER JOIN deleted d
								ON fa.Id = d.IdFatura
									AND d.Autorizado = 1
				END

			IF EXISTS ( SELECT 1 FROM inserted WHERE Autorizado = 1 )
				BEGIN
					UPDATE [dbo].[Fatura] 
						SET Saldo = (fa.Saldo + i.Valor)
						FROM [dbo].[Fatura] as fa
							INNER JOIN inserted i
								ON fa.Id = i.IdFatura
				END
>>>>>>> edf2b5a446b3355c0affd37b843f11140244e1ec
		END