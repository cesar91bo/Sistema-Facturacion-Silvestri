CREATE VIEW [dbo].[VistaDetalleFactVenta]
AS
SELECT     dbo.FacturasVentaDetalle.IdFacturaVentaDetalle, ISNULL(dbo.Articulos.DescCorta, dbo.FacturasVentaDetalle.Servicio) AS DescCorta, 
                      dbo.FacturasVentaDetalle.Cantidad, ISNULL(dbo.UnidadesMedida.Descripcion, dbo.FacturasVentaDetalle.UMedida) AS UMedida, 
                      dbo.FacturasVentaDetalle.PrecioUnitario, dbo.FacturasVentaDetalle.TotalArt, dbo.FacturasVentaDetalle.IdFacturaVenta, dbo.FacturasVentaDetalle.DesdeRemito, 
                      ISNULL(CONVERT(NVarchar, dbo.FacturasVentaDetalle.IdServicio), '') AS IdArticulo, dbo.TiposIva.PorcentajeIVA
FROM         dbo.FacturasVentaDetalle INNER JOIN
                      dbo.TiposIva ON dbo.FacturasVentaDetalle.IdTipoIva = dbo.TiposIva.IdTipoIva LEFT OUTER JOIN
                      dbo.Articulos ON dbo.FacturasVentaDetalle.IdServicio = dbo.Articulos.IdArticulo LEFT OUTER JOIN
                      dbo.UnidadesMedida ON dbo.Articulos.IdUnidadMedida = dbo.UnidadesMedida.IdUnidadMedida