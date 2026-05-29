USE RicBank2;

WITH Lancamento_Temp AS	(
							SELECT	IdSaldo,
									(CASE WHEN DebCre = 'C' THEN Valor
										ELSE (Valor * -1)
									END) AS ValorMovimento
								FROM [dbo].[Lancamento] WITH(NOLOCK)
						),

Resumo AS (
			SELECT	IdSaldo,
					SUM(ValorMovimento) AS ValorTotal
				FROM Lancamento_Temp
				GROUP BY IdSaldo
		  )

SELECT	Re.IdSaldo,
		Re.ValorTotal,
		Sd.SaldoInicial,
		Sd.Debito,
		Sd.Credito,
		(Sd.Credito - Sd.Debito - Re.ValorTotal) AS DIF
	FROM [dbo].[Saldo] AS Sd WITH(NOLOCK)
		INNER JOIN Resumo AS Re
			ON Sd.Id = Re.IdSaldo
