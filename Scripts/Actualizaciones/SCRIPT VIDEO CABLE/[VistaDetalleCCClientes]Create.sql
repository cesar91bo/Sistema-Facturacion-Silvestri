
CREATE VIEW [dbo].[VistaDetalleCCClientes]
AS
SELECT     TOP (100) PERCENT Aux.TipoDoc AS Documento, Aux.NroComprobante, Aux.Fecha, Aux.Debe, Aux.Haber, Aux.Id, Aux.FechaAcceso, 
                      Aux.FechaEmision, Aux.IdEmpresa, dbo.Empresa.RazonSocial, Aux.Cobrador
FROM         (SELECT     (CASE WHEN F.IdTipoDocumento = 8 THEN TD.Descripcion ELSE TD.Descripcion + ' ' + TF.Descripcion END) AS TipoDoc, (CASE WHEN isnull(F.NCompFact,
                                               '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, f.IdFacturaVenta) ELSE f.BVFact + '-' + f.NCompFact END) AS NroComprobante, 
                                              CONVERT(NVarchar, F.FechaEmision, 103) AS Fecha, F.Total AS Debe, 0 AS Haber, F.IdFacturaVenta AS Id, ccds.ClienteId, F.FechaAcceso, F.FechaEmision, 
                                              F.IdEmpresa, F.Cobrador
                       FROM          dbo.FacturasVenta AS F INNER JOIN
											  ClientesCajasDistribucionesServicios ccds on F.ClienteCajaDistribucionServicioId = ccds.ClienteCajaDistribucionServicioId INNER JOIN
                                              dbo.TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura INNER JOIN
                                              dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento AND F.IdTipoDocumento IN (1, 8) AND IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)
                       WHERE      (F.IdFormaPago = 2) AND (F.FechaAnulacion IS NULL)
                       UNION
					   SELECT     (CASE WHEN F.IdTipoDocumento = 8 THEN TD.Descripcion ELSE TD.Descripcion + ' ' + TF.Descripcion END) AS TipoDoc, (CASE WHEN isnull(F.NCompFact,
                                               '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, f.IdFacturaVenta) ELSE f.BVFact + '-' + f.NCompFact END) AS NroComprobante, 
                                              CONVERT(NVarchar, F.FechaEmision, 103) AS Fecha, F.Total AS Debe, 0 AS Haber, F.IdFacturaVenta AS Id, ccds.ClienteId, F.FechaAcceso, F.FechaEmision, 
                                              F.IdEmpresa, F.Cobrador
                       FROM          dbo.FacturasVenta AS F INNER JOIN
									ClientesCajasDistribucionesServicios ccds on F.ClienteCajaDistribucionServicioId = ccds.ClienteCajaDistribucionServicioId INNER JOIN
                                              dbo.TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura INNER JOIN
                                              dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento AND F.IdTipoDocumento = 9
                       WHERE      (F.IdFormaPago = 2) AND (F.FechaAnulacion IS NULL)
					   UNION
                       SELECT     TD.Descripcion AS TipoDoc, 'Nro. ' + CONVERT(Nvarchar, R.IdRecibo) AS NroComprobante, CONVERT(NVarchar, R.FechaEmision, 103) AS Fecha, 0 AS Debe,
                                              R.MontoTotal AS Haber, R.IdRecibo AS Id, R.NroCliente, R.FechaAcceso, R.FechaEmision, R.IdEmpresa, 0
                       FROM         dbo.Recibos AS R INNER JOIN
                                             dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = R.IdTipoDocumento
                       WHERE     (R.FechaBaja IS NULL)
                       UNION
                       SELECT     TD.Descripcion + ' ' + TF.Descripcion AS TipoDoc, (CASE WHEN isnull(F.NCompFact, '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, f.IdFacturaVenta) 
                                             ELSE  f.BVFact + '-' + f.NCompFact END) AS NroComprobante, CONVERT(NVarchar, F.FechaEmision, 103) AS Fecha, 0 AS Debe, 
                                             F.Total AS Haber, F.IdFacturaVenta AS Id, ccds.ClienteId, F.FechaAcceso, F.FechaEmision, F.IdEmpresa, F.Cobrador
                       FROM         dbo.FacturasVenta AS F INNER JOIN
							ClientesCajasDistribucionesServicios ccds on F.ClienteCajaDistribucionServicioId = ccds.ClienteCajaDistribucionServicioId INNER JOIN
                                             dbo.TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura INNER JOIN
                                             dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento
                       WHERE     (F.IdTipoDocumento = 2) AND (F.FechaAnulacion IS NULL) AND (F.IdFormaPago = 2)
                       UNION
                       SELECT     'Intereses' AS TipoDoc, (CASE WHEN isnull(Fv.NCompFact, '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fv.IdFacturaVenta) 
                                             ELSE fv.BVFact + '-' + fv.NCompFact END) AS NroComprobante, CONVERT(Nvarchar, dgi.Fecha, 103) AS Fecha, ISNULL(GI.TotalInteres,
                                              0) AS Debe, 0 AS Haber, fv.IdFacturaVenta, ccds.ClienteId, fv.FechaAcceso, dgi.Fecha AS FechaEmision, fv.IdEmpresa, 0
                       FROM         dbo.FacturasVenta AS fv INNER JOIN
						ClientesCajasDistribucionesServicios ccds on fv.ClienteCajaDistribucionServicioId = ccds.ClienteCajaDistribucionServicioId INNER JOIN
                                                 (SELECT     MAX(IdDiaGeneracion) AS IdDia, IdFacturaVenta
                                                   FROM          dbo.GeneracionInteres
                                                   GROUP BY IdFacturaVenta) AS AuxInt ON AuxInt.IdFacturaVenta = fv.IdFacturaVenta INNER JOIN
                                             dbo.GeneracionInteres AS GI ON GI.IdDiaGeneracion = AuxInt.IdDia AND GI.IdFacturaVenta = AuxInt.IdFacturaVenta INNER JOIN
                                             dbo.DiaGeneracionInteres AS dgi ON dgi.IdDiaGeneracion = AuxInt.IdDia
                       WHERE     (fv.FechaAnulacion IS NULL) AND (fv.IdFormaPago = 2)
					   UNION
                       SELECT     TD.Descripcion + ' ' + TF.Descripcion AS TipoDoc, (CASE WHEN isnull(F.NCompFact, '') = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, f.IdFacturaVenta) 
                                             ELSE f.BVFact + '-' + f.NCompFact END) AS NroComprobante, CONVERT(NVarchar, F.FechaEmision, 103) AS Fecha, F.Total AS Debe, 
                                             0 AS Haber, F.IdFacturaVenta AS Id, ccds.ClienteId, F.FechaAcceso, F.FechaEmision, F.IdEmpresa, F.Cobrador
                       FROM         dbo.FacturasVenta AS F INNER JOIN

						ClientesCajasDistribucionesServicios ccds on F.ClienteCajaDistribucionServicioId = ccds.ClienteCajaDistribucionServicioId INNER JOIN
                                             dbo.TiposFactura AS TF ON TF.IdTipoFactura = F.IdTipoFactura INNER JOIN
                                             dbo.TiposDocFact AS TD ON TD.IdTipoDocumento = F.IdTipoDocumento
                       WHERE     (F.IdTipoDocumento = 3) AND (F.FechaAnulacion IS NULL) AND (F.IdFormaPago = 2)) AS Aux INNER JOIN
                      dbo.Empresa ON Aux.IdEmpresa = dbo.Empresa.IdEmpresa
ORDER BY CONVERT(Datetime, Aux.Fecha)