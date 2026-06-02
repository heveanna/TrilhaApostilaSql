/*
Documentacao:
Arquivo Fonte: CTE_Dia5.sql
Objetivo: Validar a diferenca entre os lancamentos e os saldos registrados
Autor: Yure
Data Criacao: 28/05/2026

Exemplo:
	Executar apos os lancamentos do Dia 4.
*/

USE RicBank2;
GO

/* ============================================================
   CRIANDO A Lancamento_Temp
   ============================================================ */

WITH Lancamento_Temp AS (
	SELECT 
		IdSaldo,
		CASE 
			WHEN UPPER(DebCre) = 'C' THEN Valor
			ELSE (Valor * -1)
		END AS ValorMovimento
	FROM [dbo].[Lancamento] WITH(NOLOCK)
),
Resumo AS (
	SELECT 
		IdSaldo,
		SUM(ValorMovimento) AS ValorTotal
		FROM Lancamento_Temp
		GROUP BY IdSaldo
)
SELECT 
	RE.IdSaldo,
	RE.ValorTotal,
	SD.SaldoInicial,
	SD.Debito,
	SD.Credito,
	(SD.Credito - SD.Debito - RE.ValorTotal) AS DIF
	FROM [dbo].[Saldo] SD WITH(NOLOCK)
		INNER JOIN Resumo RE
			ON SD.Id = RE.IdSaldo;
GO

/*
====== VERSAO INCORRETA (PARA TESTAR) ======

WITH Lancamento_Temp AS (
    SELECT 
        IdSaldo,
        CASE 
            WHEN DebCre = 'C' THEN Valor
            ELSE (Valor * -1)
        END AS ValorMovimento
    FROM [dbo].[Lancamento] WITH (NOLOCK)
),

Resumo AS (
    SELECT 
        IdSaldo,
        SUM(ValorMovimento) AS ValorTotal
    FROM Lancamento_Temp
    GROUP BY IdSaldo
)

SELECT
    RE.IdSaldo,
    RE.ValorMovimento,
    SD.SaldoInicial,
    SD.Debito,
    SD.Credito,
    (SD.Credito - SD.Debito - RE.ValorMovimento) AS DIF
FROM [dbo].[Saldo] SD WITH (NOLOCK)
INNER JOIN Resumo RE
    ON SD.ID = RE.IdSaldo;
*/
