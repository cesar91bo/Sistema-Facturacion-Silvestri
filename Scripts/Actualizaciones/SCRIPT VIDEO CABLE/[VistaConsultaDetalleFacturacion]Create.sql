
CREATE view [dbo].[VistaConsultaDetalleFacturacion] as
select top 100 percent aux.*
from(
select FV.IdFacturaVenta, FVD.IdFacturaVentaDetalle, FV.NroFact as NroFactura, FV.FechaEmision, 
FVD.DescCorta, 
CASE WHEN FV.TipoDoc = 'Factura de Venta' THEN (CASE WHEN FV.TipoFact = 'A' THEN FVD.PrecioUnitario else (FVD.PrecioUnitario / (1+(FVD.PorcentajeIVA / 100))) END) 
else (CASE WHEN FV.TipoFact = 'A' THEN -FVD.PrecioUnitario else -(FVD.PrecioUnitario / 1+(FVD.PorcentajeIVA / 100)) END) end as PrecioUnitario,
 FVD.Cantidad, FVD.PorcentajeIVA, 
 CASE WHEN FV.TipoDoc = 'Factura de Venta' THEN (CASE WHEN FV.TipoFact = 'A' THEN FVD.TotalArt * (1+ (FVD.PorcentajeIVA / 100)) ELSE FVD.TotalArt END) ELSE 
 (CASE WHEN FV.TipoFact = 'A' THEN -(FVD.TotalArt * (1+ (FVD.PorcentajeIVA / 100))) ELSE - FVD.TotalArt END) END AS TotalArt, 
 FV.NroCliente, C.ApellidoyNombre, FV.IdEmpresa
from VistaDetalleFactVenta FVD inner join 
VistaCabFactVenta FV on fvd.IdFacturaVenta = FV.IdFacturaVenta INNER JOIN 
--ClientesCajasDistribucionesServicios ccds on FV.ClienteCajaDistribucionServicioId = ccds.ClienteCajaDistribucionServicioId
Clientes C on C.NroCliente = FV.NroCliente) as aux
order by aux.FechaEmision
