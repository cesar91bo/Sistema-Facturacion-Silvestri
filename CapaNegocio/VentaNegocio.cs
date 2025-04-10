using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class VentaNegocio
    {
        SgPymeBaseEntities db = new SgPymeBaseEntities();
        public AutenticacionesWSAA ObtenerUltimaAutorizacionWSAA()
        {
            return db.AutenticacionesWSAA.SingleOrDefault(c => c.FechaExpiracion > DateTime.Now && c.IdEmpresa == 1);
        }

        public bool NuevaAutenticacionWSAA(AutenticacionesWSAA wSAA)
        {
            try
            {
                AgregarAutenticacionesWSAA(wSAA);
                Grabar();
            }
            catch (Exception ex)
            {

                throw ex;
            }
            return true;
        }

        private void Grabar()
        {
            db.SaveChanges();
        }

        private void AgregarAutenticacionesWSAA(AutenticacionesWSAA wSAA)
        {
            db.AutenticacionesWSAA.Add(wSAA);
        }

        public FacturasVenta ObtenerFactura(Int32 idFact)
        {
            return db.FacturasVenta.SingleOrDefault(c => c.IdFacturaVenta == idFact);
        }

        public FacturasVentaDetalle ObtenerFacturaVentaDetalle(Int64 idFactD)
        {
            return db.FacturasVentaDetalle.SingleOrDefault(c => c.IdFacturaVentaDetalle == idFactD);
        }

        public Boolean EditarFactura(FacturasVenta _factura)
        {
            try
            {
                FacturasVenta facturasVenta = ObtenerFactura(_factura.IdFacturaVenta);
                facturasVenta.Total = _factura.Total;
                facturasVenta.Subtotal21 = _factura.Subtotal21;
                facturasVenta.SubTotal = _factura.SubTotal;
                facturasVenta.TotalIva21 = _factura.TotalIva21;
                facturasVenta.IdFormaPago = _factura.IdFormaPago;
                Grabar();
                return true;
            }
            catch (Exception ex) { throw ex; }
        }

        public Boolean EditarFacturaVentaDetalle(FacturasVentaDetalle _facturaDetalle)
        {
            try
            {
                FacturasVentaDetalle facturasVentaD = ObtenerFacturaVentaDetalle(_facturaDetalle.IdFacturaVentaDetalle);
                facturasVentaD.TotalArt = _facturaDetalle.TotalArt;
                facturasVentaD.PrecioUnitario = _facturaDetalle.PrecioUnitario;
                facturasVentaD.Servicio = _facturaDetalle.Servicio;
                Grabar();
                return true;
            }
            catch (Exception ex) { throw ex; }
        }

        public VistaLibroIvaVenta ObtenerLibroIvaVentasPorIdFactura(Int32 IdFactura)
        {
            return db.VistaLibroIvaVenta.SingleOrDefault(c => c.IdFacturaVenta == IdFactura);
        }

        public VistaTotalesDiscriminadosFactB ObtenerVistaTotalesDiscriminadosFactBporIdFact(Int32 IdFactura)
        {
            return db.VistaTotalesDiscriminadosFactB.SingleOrDefault(c => c.IdFacturaVenta == IdFactura);
        }

        public List<FacturasVentaDetalle> ObtenerFacturaVentaDetallexTipoIvayNroFact(Int32 IdFact, Int32 IdTipoIva)
        {
            var detalle = from f in db.FacturasVentaDetalle
                          where IdFact == f.IdFacturaVenta && f.IdTipoIva == IdTipoIva
                          select f;
            return detalle.ToList();
        }

        public void ActualizaNroFact(Int32 IdFact, Int32 NroComp, string bocaVenta, Int16 IdEmp)
        {
            try
            {
                FacturasVenta fv = ObtenerFactura(IdFact);
                fv.Impresa = true;
                fv.BVFact = bocaVenta;
                fv.NCompFact = NroComp.ToString().PadLeft(8, '0');
                fv.FechaEmision = DateTime.Now;
                fv.Pagado = true;
                Grabar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool NuevaFacturaElectronica(FacturasElectronicas Fact)
        {
            try
            {
                AgregarFacturaElectronica(Fact);
                Grabar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return true;
        }

        private void AgregarFacturaElectronica(FacturasElectronicas fact)
        {
            db.FacturasElectronicas.Add(fact);
        }

        public string ObtenerUltimoNroCompRemitoX(Int16 IdEmp)
        {
            var f = from v in db.FacturasVenta
                    where v.IdEmpresa == IdEmp && v.IdTipoDocumento == 8
                    select v;
            if (f.Any())
            {
                FacturasVenta Ultimo = db.FacturasVenta.SingleOrDefault(c => c.IdFacturaVenta == f.Max(d => d.IdFacturaVenta));
                if (Ultimo.NCompFact == "99999999") return (Convert.ToInt64(Ultimo.BVFact) + 1).ToString().PadLeft(4, '0') + "-" + "00000001";
                return Ultimo.BVFact + "-" + (Convert.ToInt64(Ultimo.NCompFact) + 1).ToString().PadLeft(8, '0');
            }
            return "0001-00000001";
        }

        public List<VistaDetalleFactVenta> ObtenerVistaDetalledeFacturaVta(int IdFact)
        {
            var det = from d in db.VistaDetalleFactVenta
                      where d.IdFacturaVenta == IdFact
                      select d;
            return det.ToList();
        }

        public List<FacturasVentaDetalle> ObtenerDetalledeFacturaVta(int IdFact)
        {
            var det = from d in db.FacturasVentaDetalle
                      where d.IdFacturaVenta == IdFact
                      select d;
            return det.ToList();
        }
    }
}
