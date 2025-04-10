CREATE VIEW [dbo].[VistaNCsinSaldar]
AS
SELECT     fv.IdFacturaVenta, c.NroCliente, fv.BVFact + '-' + fv.NCompFact AS NroFactura, fv.IdEmpresa, fv.Total, 
				SUM(ISNULL(cf.MontoCancelacion, 0)) AS TotalSaldado, (fv.Total - SUM(ISNULL(cf.MontoCancelacion, 0))) as Pendiente,
                      fv.FechaEmision, fv.FechaAnulacion, cf.IdNotaCredito, c.ApellidoyNombre, C.Direccion, FV.IdTipoFactura, fv.Cobrador					  
FROM         FacturasVenta AS fv LEFT OUTER JOIN
                      CancelacionFacturas AS cf ON cf.IdNotaCredito = fv.IdFacturaVenta AND cf.FechaAnulacion IS NULL INNER JOIN
					  ClientesCajasDistribucionesServicios ccds on fv.ClienteCajaDistribucionServicioId = ccds.ClienteCajaDistribucionServicioId INNER JOIN
                      Clientes C on ccds.ClienteCajaDistribucionServicioId = c.NroCliente
WHERE     (fv.IdFormaPago = 2) AND (fv.FechaAnulacion is null) AND (fv.IdTipoDocumento = 2) AND C.FechaBaja is null
GROUP BY fv.IdFacturaVenta, c.NroCliente, fv.BVFact + '-' + fv.NCompFact, fv.IdEmpresa, fv.Total, fv.FechaEmision, 
fv.FechaAnulacion, cf.IdNotaCredito, c.ApellidoyNombre, C.Direccion, FV.IdTipoFactura, fv.Cobrador
HAVING (fv.Total > SUM(ISNULL(cf.MontoCancelacion, 0)))