CREATE VIEW [dbo].[CabeceraArchivoFact]
AS
SELECT     FV.IdTipoDocumento, TF.Descripcion AS TipoF, FV.Subtotal - FV.TotalDescuento AS Dto, FV.Observaciones, FP.Descripcion AS FPago, 
                      C.ApellidoyNombre AS RazonSocial, ISNULL(C.TipoDocumento, 'CUIT') AS TipoDoc, ISNULL(C.NroDocumento, C.Cuit0 + C.Cuit1 + C.Cuit2) AS NroDoc, 
                      RI.Descripcion AS RegImp, C.Direccion, FV.IdFacturaVenta
FROM         dbo.FacturasVenta AS FV INNER JOIN
                      --dbo.Clientes AS C ON C.NroCliente = FV.NroCliente INNER JOIN
                      dbo.FormasPago AS FP ON FP.IdFormaPago = FV.IdFormaPago INNER JOIN                       
                      dbo.TiposFactura AS TF ON TF.IdTipoFactura = FV.IdTipoFactura  INNER JOIN
					  dbo.ClientesCajasDistribucionesServicios AS CCDS ON CCDS.ClienteCajaDistribucionServicioId = FV.ClienteCajaDistribucionServicioId  INNER JOIN
					  dbo.Clientes AS C ON C.NroCliente = CCDS.ClienteId INNER JOIN
					  dbo.RegimenesImpositivos AS RI ON RI.IdRegimenImpositivo = C.IdRegimenImpositivo 

