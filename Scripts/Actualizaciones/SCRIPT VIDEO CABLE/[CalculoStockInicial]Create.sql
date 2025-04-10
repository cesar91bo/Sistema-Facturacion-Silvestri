CREATE VIEW [dbo].[CalculoStockInicial]
AS
SELECT     A.IdArticulo, A.StockActual, ISNULL(SUM(Aux.Ingreso), 0) AS Restar, ISNULL(SUM(Aux.Egreso), 0) AS sumar, ISNULL(A.StockActual + SUM(Aux.Egreso) 
                      - SUM(Aux.Ingreso), A.StockActual) AS StockInicial, CONVERT(Nvarchar, A.FechaAcceso, 103) AS Fecha
FROM         dbo.Articulos AS A LEFT OUTER JOIN
                      dbo.VistaMovStock AS Aux ON Aux.IdServicio = A.IdArticulo
GROUP BY A.IdArticulo, A.StockActual, A.FechaAcceso