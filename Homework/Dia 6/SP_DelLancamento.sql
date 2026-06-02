-- Dia 06 |Fazer uma procedure para atualização e para exclusão de [dbo].[Lancamento]. 

-- PROC DELETE

USE RicBank2;
GO

-- Verificando se a proc já existe, se sim drop

IF EXISTS	(
				SELECT 1 
					FROM [sys].[sysobjects]
					WHERE Id = OBJECT_ID(N'[dbo].[SP_DelLancamento]')
						AND OBJECTPROPERTY(Id, N'IsProcedure') = 1
			)
	BEGIN 
		DROP PROCEDURE [dbo].[SP_DelLancamento];
		END

GO

-- Criar procedure 

CREATE PROC [dbo].[SP_DelLancamento]
	@IdLancamento INT
	AS 
	/* DOCUMENTAÇÃO

		Arquivo Fonte: SP_DelLancamento.sql
		Objetivo: Deletar um lancamento da tabela [dbo].[Lancamento]
		Autor: Djefferson dos Santos Lima
		Data criação: 01/06/2026

		Exemplo:
			BEGIN TRAN
				
				DECLARE	@RET INT,
						@DAT_INI DATETIME = GETDATE();

				SELECT * FROM [dbo].[Lancamento] WHERE Id = 1;

				EXEC @RET = [dbo].[SP_DelLancamento]	@IdLancamento = 1;

				SELECT	@RET AS Retorno,
						DATEDIFF (MILLISECOND, @DAT_INI, GETDATE()) AS 'Tempo (ms)';

				IF NOT EXISTS	(
									SELECT * FROM [dbo].[Lancamento] WHERE Id = 1
								)
					BEGIN
						SELECT 'Existe mais n pae';
						END
				ELSE
					BEGIN
						SELECT * FROM [dbo].[Lancamento] WHERE Id = 1;
						END

				ROLLBACK TRAN

		Retornos:	-1 - Falha na Execução
					Retorno positivo se refere ao ID do Lançamento

	*/

	BEGIN
		DECLARE	@ERRO			INT

		DELETE FROM [dbo].[Lancamento]
			WHERE Id = @IdLancamento;

		SELECT	@Erro	= @@ERROR;

		IF @Erro <> 0
			BEGIN	
				RETURN -1;
				END

		RETURN @IdLancamento;
	END
GO
		