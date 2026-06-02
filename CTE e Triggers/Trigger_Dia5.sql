/*
Documentacao:
Arquivo Fonte: Trigger_Dia5.sql
Objetivo: Criar trigger para atualizar saldo em inclusoes, alteracoes e exclusoes de lancamentos
Autor: Yure
Data Criacao: 28/05/2026

Exemplo:
	Executar apos Modelagem.sql.
*/

USE RicBank2;
GO

/* ============================================================
   CRIANDO TRIGGERS
   ============================================================ */

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects]
				WHERE ID = Object_Id (N'[dbo].[TRG_AtualizarSaldo]')
					AND TYPE = 'TR')
   BEGIN 
		DROP TRIGGER [dbo].[TRG_AtualizarSaldo]
   END
GO

		CREATE TRIGGER [dbo].[TRG_AtualizarSaldo]
			ON [dbo].[Lancamento]
			FOR INSERT, DELETE, UPDATE
			
			/*
			Documentacao:
			Arquivo Fonte: Trigger_Dia5.sql
			Objetivo: Atualizar saldo conforme inclusoes, alteracoes e exclusoes de lancamento
			Autor: Yure
			Data Criacao: 28/05/2026

			Exemplo:
				INSERT INTO [dbo].[Lancamento](IdSaldo, DataLancamento, Historico, DebCre, Valor)
					VALUES (8, GETDATE(), 'Transferencia recebida - TED', 'C', 100.00);
			*/

			AS
			BEGIN
				SET NOCOUNT ON

				WITH Movimentos AS (
					SELECT 
						IdSaldo,
						SUM(CASE WHEN UPPER(DebCre) = 'C' THEN Valor * -1 ELSE 0 END) AS Credito,
						SUM(CASE WHEN UPPER(DebCre) = 'D' THEN Valor * -1 ELSE 0 END) AS Debito
						FROM deleted
						GROUP BY IdSaldo

					UNION ALL

					SELECT 
						IdSaldo,
						SUM(CASE WHEN UPPER(DebCre) = 'C' THEN Valor ELSE 0 END) AS Credito,
						SUM(CASE WHEN UPPER(DebCre) = 'D' THEN Valor ELSE 0 END) AS Debito
						FROM inserted
						GROUP BY IdSaldo
				),
				Resumo AS (
					SELECT 
						IdSaldo,
						SUM(Credito) AS Credito,
						SUM(Debito) AS Debito
						FROM Movimentos
						GROUP BY IdSaldo
				)
				UPDATE SD 
					SET SD.Credito = SD.Credito + RE.Credito,
						SD.Debito = SD.Debito + RE.Debito
					FROM [dbo].[Saldo] SD 
						INNER JOIN Resumo RE 
							ON SD.ID = RE.IdSaldo
			END
GO

/* ============================================================
   INSERINDO LANCAMENTO PARA TESTAR TRIGGER
   ============================================================ */

INSERT INTO [dbo].[Lancamento](IdSaldo, DataLancamento, Historico, DebCre, Valor)
	VALUES
		(31, GETDATE(), 'Recebimento de PIX', 'C', 250.00);
GO

SELECT *
	FROM [dbo].[Saldo]
	WHERE Id = 31;
GO

DELETE FROM [dbo].[Lancamento]
	WHERE IdSaldo = 31
		AND Historico = 'Recebimento de PIX';
GO
