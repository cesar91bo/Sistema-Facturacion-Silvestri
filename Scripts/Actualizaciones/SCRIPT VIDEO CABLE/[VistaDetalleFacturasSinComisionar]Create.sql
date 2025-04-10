
CREATE view [dbo].[VistaDetalleFacturasSinComisionar] as
select FV.BVFact + '-' + FV.NCompFact as NroFactura, FV.IdFacturaVenta, FVD.IdFacturaVentaDetalle, A.IdArticulo,
A.DescCorta as Articulo, V.PorcComision, VFV.MontoComision, FV.Total, FV.FechaEmision, VFV.NroVendedor
from FacturasVentaDetalle FVD inner join 
FacturasVenta FV on FV.IdFacturaVenta = FVD.IdFacturaVenta INNER JOIN
VendedoresFacturasVenta VFV on VFV.IdFacturaVenta = FV.IdFacturaVenta INNER JOIN
Articulos A on FVD.IdServicio = A.IdArticulo INNER JOIN 
Vendedores V on V.NroVendedor = VFV.NroVendedor LEFT JOIN
VistaTotalesComisionesFacturas VTC on VTC.IdFacturaVenta = FV.IdFacturaVenta and VFV.NroVendedor = VTC.NroVendedor

where FV.FechaAnulacion is null and VFV.MontoComision > 0 and VFV.MontoComision > ISNULL(VTC.TotalComisionado, 0)