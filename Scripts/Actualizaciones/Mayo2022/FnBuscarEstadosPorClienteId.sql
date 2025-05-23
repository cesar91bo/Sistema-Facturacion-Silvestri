USE [SgPymeBase]
GO
/****** Object:  UserDefinedFunction [dbo].[FnBuscarEstadosPorClienteId]    Script Date: 5/3/2022 7:33:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ojeda, JOse
-- Create date: 2022-04-28
-- Description:	Devuelve un listado de los estados de un cliente, filtrando por ClienteCajaDistribucionServicioId
-- =============================================
create FUNCTION [dbo].[FnBuscarEstadosPorClienteId] 
(	
	@ClienteCajaDistribucionServicioId int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		ccdse.ClienteCajaDistribucionServicioEstadoId,
		es.Descripcion,
		ccdse.FechaUltimaModificacion,
		ccdse.Observaciones,
		Fila = ROW_NUMBER() OVER (ORDER BY ccdse.FechaUltimaModificacion DESC)  --< ORDER BY
	
	FROM Clientes cli
		INNER JOIN ClientesCajasDistribucionesServicios ccds on cli.NroCliente = ccds.ClienteId
		INNER JOIN ClientesCajasDistribucionesServiciosEstados ccdse on ccds.ClienteCajaDistribucionServicioId = ccdse.ClienteCajaDistribucionServicioId
		INNER JOIN Estados es on ccdse.EstadoId = es.EstadoId

	WHERE  ccds.ClienteCajaDistribucionServicioId = @ClienteCajaDistribucionServicioId
)
