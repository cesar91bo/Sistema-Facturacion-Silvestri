
CREATE view [dbo].[VistaDetalleMovimientosDepositos] as

select top 100 percent aux.FechaMovimiento, aux.Deposito, aux.IdDeposito, aux.TipoMovimiento, aux.IdTipoMovDeposito, aux.Ingreso,
aux.Egreso, aux.DepositoSecundario, aux.IdDepositoSecundario, aux.IdArticulo, aux.DescCorta
from (
select VMD.FechaMovimiento, VMD.Deposito, VMD.IdDeposito, VMD.TipoMovimiento, VMD.IdTipoMovDeposito, VMD.Cantidad as Ingreso, 0 as Egreso, isnull(VMD.DepositoSecundario,'') as DepositoSecundario, 
isnull(VMD.IdDepositoSecundario,0) as IdDepositoSecundario,VMD.IdArticulo, VMD.DescCorta
from VistaMovimientosDepositos VMD inner join
Articulos A on A.IdArticulo = VMD.IdArticulo
where VMD.IdTipoMovDeposito = 1 and A.LlevarStock = 1

union

select VMD.FechaMovimiento, VMD.Deposito, VMD.IdDeposito, VMD.TipoMovimiento, VMD.IdTipoMovDeposito, 0 as Ingreso, VMD.Cantidad as Egreso, isnull(VMD.DepositoSecundario,'') as DepositoSecundario,
isnull(VMD.IdDepositoSecundario,0) as IdDepositoSecundario, VMD.IdArticulo, VMD.DescCorta
from VistaMovimientosDepositos VMD inner join
Articulos A on A.IdArticulo = VMD.IdArticulo 
where VMD.IdTipoMovDeposito = 2 and A.LlevarStock = 1

union

select VMD.FechaMovimiento, VMD.Deposito, VMD.IdDeposito, VMD.TipoMovimiento, VMD.IdTipoMovDeposito, 0 as Ingreso, VMD.Cantidad as Egreso, isnull(VMD.DepositoSecundario,'') as DepositoSecundario, 
VMD.IdDepositoSecundario, VMD.IdArticulo, VMD.DescCorta
from VistaMovimientosDepositos VMD inner join 
Articulos A on A.IdArticulo = vmd.IdArticulo
where VMD.IdTipoMovDeposito = 3 and A.LlevarStock = 1

union

select VMD.FechaMovimiento, VMD.DepositoSecundario, VMD.IdDepositoSecundario, 'Traslado de Deposito: ' + vmd.Deposito as TipoMov, VMD.IdTipoMovDeposito, VMD.Cantidad as Ingreso, 0 as Egreso, 
'-' as DepositoSecundario, VMD.IdDeposito, VMD.IdArticulo, VMD.DescCorta
from VistaMovimientosDepositos VMD inner join 
Articulos A on A.IdArticulo = VMD.IdArticulo
where VMD.IdTipoMovDeposito = 3 and A.LlevarStock = 1

union 

Select VMS.FechaConMinutos, D.Descripcion as Deposito, 1, VMS.Movimiento,
Case when  vms.Ingreso > 0 THEN 1 when VMS.Egreso > 0 then 2 end as IdTipoMovimiento,
VMS.Ingreso as Ingreso, VMS.Egreso as Egreso, null as DepositoSecundario, null as IdDepositoSecundario, VMS.IdServicio, A.DescCorta
from VistaMovStock VMS inner join
Depositos D on D.IdDeposito = 1 INNER JOIN 
Articulos A on A.IdArticulo = VMS.IdServicio
where A.LlevarStock = 1) as aux
order by aux.FechaMovimiento 