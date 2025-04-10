USE [SgPymeBase]
GO

/****** Object:  View [dbo].[VistaClientes]    Script Date: 12/04/2022 0:06:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [dbo].[VistaClientes]
AS
SELECT      TOP (100) PERCENT dbo.Clientes.NroCliente, dbo.Clientes.ApellidoyNombre, ISNULL(dbo.Clientes.TipoDocumento, '') AS TipoDocumento, ISNULL(CONVERT(Nvarchar, dbo.Clientes.NroDocumento), '') AS [Nro.Doc], 
                         dbo.Clientes.Direccion, dbo.RegimenesImpositivos.Descripcion, dbo.CPostales.Localidad, dbo.Clientes.FechaNacimiento, dbo.Clientes.Telefono, dbo.Clientes.Email1, dbo.Clientes.Email2, dbo.Provincias.Provincia, 
                         (CASE WHEN dbo.Clientes.Cuit0 IS NULL THEN '' ELSE (dbo.Clientes.Cuit0 + '-' + dbo.Clientes.Cuit1 + '-' + Isnull(dbo.Clientes.Cuit2, '')) END) AS Cuit, ISNULL(CONVERT(Nvarchar, dbo.Clientes.FechaBaja, 103), '') AS FechaBaja, 
                         dbo.Clientes.Comentario, dbo.Clientes.CodigoPostal, dbo.CajasDistribuciones.Descipcion, dbo.ClientesCajasDistribucionesServicios.ClienteCajaDistribucionServicioId
FROM         dbo.Clientes INNER JOIN
                         dbo.RegimenesImpositivos ON dbo.Clientes.IdRegimenImpositivo = dbo.RegimenesImpositivos.IdRegimenImpositivo INNER JOIN
                         dbo.CPostales ON dbo.Clientes.CodigoPostal = dbo.CPostales.CodigoPostal AND dbo.Clientes.SubCodigoPostal = dbo.CPostales.SubCodigoPostal INNER JOIN
                         dbo.Provincias ON dbo.CPostales.IdProvincia = dbo.Provincias.IdProvincia INNER JOIN
                         dbo.ClientesCajasDistribucionesServicios ON dbo.Clientes.NroCliente = dbo.ClientesCajasDistribucionesServicios.ClienteId INNER JOIN
                         dbo.CajasDistribuciones ON dbo.ClientesCajasDistribucionesServicios.CajaDistribucionId = dbo.CajasDistribuciones.CajaDistribucionId INNER JOIN
                         dbo.Servicios AS s ON dbo.ClientesCajasDistribucionesServicios.ServicioId = s.ServicioId

ORDER BY dbo.Clientes.NroCliente


GO


