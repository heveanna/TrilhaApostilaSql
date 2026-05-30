-- Fazer uma procedure para atualização e para exclusão de [dbo].[Lancamento].
USE RicBank2;
GO
-- Procedure para atualização de dados na tabela [dbo].[Lancamento] ---------------------------------

IF EXISTS	(
				SELECT 1 FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[UpdateLancamento]')
						AND OBJECTPROPERTY(Id, N'IsProcedure') = 1
			)
	BEGIN
		DROP PROCEDURE [dbo].[UpdateLancamento]
		END
GO

CREATE PROC [dbo].[UpdateLancamento]
	@IdLancamento INT,
	@IdSaldo INT = NULL,
	@DataLancamento DATETIME = NULL,
	@Historico VARCHAR(200) = NULL,
	@DebCre CHAR(1) = NULL,
	@Valor DECIMAL(10, 2) = NULL
	AS
	/* DOCUMENTAÇÃO

		Código Fonte: Procedures
		Objetivo: Atualizar atributos da tabela [dbo].[Lancamento], os campos não preenchidos não serão modificados.
		Autor: Djefferson dos Santos Lima
		Data criação: 30/05/2026

		Exemplo:
			BEGIN TRAN
				DECLARE	@DataInicial DATETIME  = GETDATE();
					
				EXEC [dbo].[UpdateLancamento]	@IdLancamento = 1,
												@IdSaldo = NULL, -- Por padrão, quando não preenchido, o valor é nulo. Ou seja, esse campo é desnecessário.
												@DataLancamento = @DataInicial,
												@Historico = 'Teste UpdateLancamento',
												@DebCre = 'D',
												@Valor = 50000;
				SELECT	Id,
						IdSaldo,
						DataLancamento,
						Historico,
						DebCre,
						Valor
					FROM [dbo].[Lancamento] WITH(NOLOCK)
					WHERE Id = 1;

				ROLLBACK TRAN

				SELECT	Id,
						IdSaldo,
						DataLancamento,
						Historico,
						DebCre,
						Valor
					FROM [dbo].[Lancamento] WITH(NOLOCK)
					WHERE Id = 1;
			GO

		
		Retornos:	Erro:		Exibir as duas tabelas com valores iguais ou
								exibir nenhum valor nas tabelas.
					
					Sucesso:	Exibir a primeira tabela com os novos valores
								e a segunda com os valores antigos.
	*/
	BEGIN

		BEGIN TRY

			BEGIN TRAN

				UPDATE [dbo].[Lancamento]
					SET	IdSaldo = ISNULL(@IdSaldo, IdSaldo),
						DataLancamento = ISNULL(@DataLancamento, DataLancamento),
						Historico = ISNULL(@Historico, Historico),
						DebCre = ISNULL(@DebCre, DebCre),
						Valor = ISNULL(@Valor, Valor)
					WHERE Id = @IdLancamento

				COMMIT TRAN
				PRINT 'Sucesso: Lançamento atualizado.';

			END TRY

			BEGIN CATCH

				IF @@TRANCOUNT > 0
					ROLLBACK TRAN;
				PRINT 'Erro: não foi possível realizar a atualização.'

				END CATCH

		END
GO
