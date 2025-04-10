CREATE VIEW [dbo].[VistaMovStock]
AS
SELECT     TOP (100) PERCENT Movimiento, CONVERT(Nvarchar, Fecha, 103) AS Fecha, Ingreso, Egreso, IdServicio, ID, Fecha as FechaConMinutos
FROM         (SELECT     fv.IdFacturaVenta AS ID, fvd.IdServicio, Tdf.Descripcion + ' ' + Tf.Descripcion + ' - ' + (CASE WHEN isnull(Fv.NCompFact, '') 
                                              = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fv.IdFacturaVenta) ELSE 'Nro.Comprobante ' + fv.BVFact + '-' + fv.NCompFact END) AS Movimiento, 
                                              fv.FechaEmision AS Fecha, 0 AS Ingreso, fvd.Cantidad AS Egreso
                       FROM          dbo.FacturasVenta AS fv INNER JOIN
                                              dbo.FacturasVentaDetalle AS fvd ON fv.IdFacturaVenta = fvd.IdFacturaVenta AND fvd.DesdeRemito = 0 AND fvd.IdServicio IS NOT NULL INNER JOIN
                                              dbo.TiposDocFact AS Tdf ON Tdf.IdTipoDocumento = fv.IdTipoDocumento INNER JOIN
                                              dbo.TiposFactura AS Tf ON Tf.IdTipoFactura = fv.IdTipoFactura
                       WHERE      (fv.IdTipoDocumento = 1 OR fv.IdTipoDocumento = 8) AND (fv.FechaAnulacion IS NULL) AND fvd.MueveStock = 1 AND fv.IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)
                       UNION
                       SELECT     R.IdRemito AS ID, RD.IdArticulo, 'Remito vta. Nro. ' + R.NroRemito AS Movimiento, R.FechaRemito AS Fecha, 0 AS Ingreso, RD.Cantidad AS Egreso
                       FROM         dbo.Remitos AS R INNER JOIN
                                             dbo.RemitosDetalle AS RD ON RD.IdRemito = R.IdRemito
						WHERE	RD.MueveStock = 1 and R.FechaAnulacion is null
                       UNION
                       SELECT     fv.IdFacturaVenta AS ID, fvd.IdServicio, Tdf.Descripcion + ' ' + Tf.Descripcion + ' - ' + (CASE WHEN isnull(Fv.NCompFact, '') 
                                             = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fv.IdFacturaVenta) ELSE 'Nro.Comprobante ' + fv.BVFact + '-' + fv.NCompFact END) AS Movimiento, 
                                             fv.FechaEmision AS Fecha, fvd.Cantidad AS Ingreso, 0 AS Egreso
                       FROM         dbo.FacturasVenta AS fv INNER JOIN
                                             dbo.FacturasVentaDetalle AS fvd ON fv.IdFacturaVenta = fvd.IdFacturaVenta AND fvd.IdServicio IS NOT NULL INNER JOIN
                                             dbo.TiposDocFact AS Tdf ON Tdf.IdTipoDocumento = fv.IdTipoDocumento INNER JOIN
                                             dbo.TiposFactura AS Tf ON Tf.IdTipoFactura = fv.IdTipoFactura
                       WHERE     (fv.IdTipoDocumento = 2) AND (fv.FechaAnulacion IS NULL) AND fvd.MueveStock = 1
                       UNION
                       SELECT     RC.IdRemitoCompra AS ID, RDC.IdArticulo, 'Remito cpra. Nro. ' + RC.BVRemCompra + '-' + RC.NroCompRemCompra AS Movimiento, 
                                             RC.FechaRemitoCompra AS Fecha, RDC.Cantidad AS Ingreso, 0 AS Egreso
                       FROM         dbo.RemitosCompra AS RC INNER JOIN
                                             dbo.RemitosDetalleCompra AS RDC ON RDC.IdRemitoCompra = RC.IdRemitoCompra
                       WHERE		RDC.MueveStock = 1
					   UNION
                       SELECT     fC.IdFacturaCompra AS ID, fcd.IdArticulo, Tdf.Descripcion + ' ' + Tf.Descripcion + ' - ' + (CASE WHEN isnull(fC.NCompFactCompra, '') 
                                             = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fc.IdFacturaCompra) ELSE 'Nro.Comprobante ' + fc.BVFactCompra + '-' + fc.NCompFactCompra END) 
                                             AS Movimiento, fC.FechaEmision AS Fecha, fcd.Cantidad AS Ingreso, 0 AS Egreso
                       FROM         dbo.FacturasCompra AS fC INNER JOIN
                                             dbo.FacturasCompraDetalle AS fcd ON fC.IdFacturaCompra = fcd.IdFacturaCompra AND fcd.DesdeRemito = 0 AND fcd.IdArticulo IS NOT NULL INNER JOIN
                                             dbo.TiposDocFact AS Tdf ON Tdf.IdTipoDocumento = fC.IdTipoDocumento INNER JOIN
                                             dbo.TiposFactura AS Tf ON Tf.IdTipoFactura = fC.IdTipoFactura
                       WHERE     (fC.IdTipoDocumento = 4) AND (fC.FechaAnulacion IS NULL) AND fcd.MueveStock = 1
                       UNION
                       SELECT     fc.IdFacturaCompra AS ID, fcd.IdArticulo, Tdf.Descripcion + ' ' + Tf.Descripcion + ' - ' + (CASE WHEN isnull(Fc.NCompFactCompra, '') 
                                             = '' THEN 'Nro. Interno ' + CONVERT(Nvarchar, fc.IdFacturaCompra) ELSE 'Nro.Comprobante ' + fc.BVFactCompra + '-' + fc.NCompFactCompra END) 
                                             AS Movimiento, fc.FechaEmision AS Fecha, 0 AS Ingreso, fcd.Cantidad AS Egreso
                       FROM         dbo.FacturasCompra AS fc INNER JOIN
                                             dbo.FacturasCompraDetalle AS fcd ON fc.IdFacturaCompra = fcd.IdFacturaCompra AND fcd.IdArticulo IS NOT NULL INNER JOIN
                                             dbo.TiposDocFact AS Tdf ON Tdf.IdTipoDocumento = fc.IdTipoDocumento INNER JOIN
                                             dbo.TiposFactura AS Tf ON Tf.IdTipoFactura = fc.IdTipoFactura
                       WHERE     (fc.IdTipoDocumento = 7) AND (fc.FechaAnulacion IS NULL) AND fcd.MueveStock = 1
					   

                       UNION
                       SELECT     IdAjuste AS ID, IdArticulo, 'Ajuste de Stock, motivo: ' + ISNULL(Motivo, 'No se cargó motivo.') AS Movimiento, FechaAjuste AS Fecha, 
                                             (CASE WHEN Aj.Cantidad > 0 THEN Aj.Cantidad ELSE 0 END) AS Ingreso, (CASE WHEN Aj.Cantidad < 0 THEN - Aj.Cantidad ELSE 0 END) AS Egreso
                       FROM         dbo.AjustesStock AS Aj) AS Aux
ORDER BY FechaConMinutos
