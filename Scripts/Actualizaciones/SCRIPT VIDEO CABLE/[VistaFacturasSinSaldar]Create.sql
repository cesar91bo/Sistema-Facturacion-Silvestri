CREATE VIEW [dbo].[VistaFacturasSinSaldar]
AS
select fv.IdFacturaVenta, c.NroCliente, fv.BVFact + '-' + fv.NCompFact AS NroFactura, fv.Total, fv.IdTipoDocumento, fv.IdTipoFactura,
	SUM(ISNULL(cf.MontoCancelacion, 0)) as TotalSaldado, fv.Total  - SUM(ISNULL(cf.MontoCancelacion, 0)) as PendienteCobro, 
	fv.FechaEmision, c.ApellidoyNombre, c.Direccion, NroDocumento, cuit0 + '-' + cuit1 + '-' + cuit2 as CUIT, IdEmpresa	
from FacturasVenta fv left join CancelacionFacturas cf
on fv.IdFacturaVenta = cf.IdFacturaVenta and cf.FechaAnulacion is null
inner join ClientesCajasDistribucionesServicios ccds on fv.ClienteCajaDistribucionServicioId = ccds.ClienteCajaDistribucionServicioId
inner join Clientes c on ccds.ClienteId = c.NroCliente and c.FechaBaja is null
where (fv.IdFormaPago = 2) AND (fv.FechaAnulacion is null) and (fv.IdTipoDocumento in (1,8)) 
and fv.IdFacturaVenta not in (select IdFacturaVenta from RemitosXfacturados)
group by fv.IdFacturaVenta, c.NroCliente, fv.BVFact + '-' + fv.NCompFact, fv.Total, fv.IdTipoDocumento, 
			fv.IdTipoFactura, fv.FechaEmision, c.ApellidoyNombre, c.Direccion, NroDocumento, cuit0 + '-' + cuit1 + '-' + cuit2, IdEmpresa
having fv.Total > SUM(ISNULL(cf.MontoCancelacion, 0))