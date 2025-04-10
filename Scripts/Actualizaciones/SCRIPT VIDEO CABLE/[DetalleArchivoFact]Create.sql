CREATE VIEW [dbo].[DetalleArchivoFact]
AS
SELECT        ISNULL(A.DescCorta, FVD.Servicio) AS Articulo, ISNULL(UM.Descripcion, FVD.UMedida) AS UMedida, FVD.Cantidad, FVD.PrecioUnitario, ISNULL(TI.PorcentajeIVA, 21) 
                         AS IVA, FVD.IdFacturaVenta
FROM            dbo.FacturasVentaDetalle AS FVD LEFT OUTER JOIN
                         dbo.Articulos AS A ON A.IdArticulo = FVD.IdServicio LEFT OUTER JOIN
                         dbo.UnidadesMedida AS UM ON UM.IdUnidadMedida = A.IdUnidadMedida LEFT OUTER JOIN
                             (SELECT        IdTipoIva, IdArticulo, MAX(FechaPrecios) AS Fecha
                               FROM            dbo.PreciosVenta
                               GROUP BY IdTipoIva, IdArticulo) AS aux ON aux.IdArticulo = A.IdArticulo LEFT OUTER JOIN
                         dbo.TiposIva AS TI ON TI.IdTipoIva = aux.IdTipoIva