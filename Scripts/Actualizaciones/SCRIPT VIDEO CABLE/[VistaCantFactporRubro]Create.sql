CREATE VIEW [dbo].[VistaCantFactporRubro]
AS
SELECT     TOP (100) PERCENT R.Descripcion AS Rubro, CONVERT(Decimal(10, 2), SUM(FVD.Cantidad * FVD.PrecioUnitario)) AS TotalFacturado, R.IdRubro, FV.IdEmpresa
FROM         dbo.FacturasVenta AS FV INNER JOIN
                      dbo.FacturasVentaDetalle AS FVD ON FV.IdFacturaVenta = FVD.IdFacturaVenta INNER JOIN
                      dbo.Articulos AS A ON A.IdArticulo = FVD.IdServicio INNER JOIN
                      dbo.Rubros AS R ON R.IdRubro = A.IdRubro INNER JOIN
                      dbo.SubRubros AS S ON S.IdSubRubro = A.IdSubRubro
WHERE     (FV.FechaAnulacion IS NULL)
GROUP BY R.Descripcion, R.IdRubro, FV.IdEmpresa
ORDER BY TotalFacturado DESC