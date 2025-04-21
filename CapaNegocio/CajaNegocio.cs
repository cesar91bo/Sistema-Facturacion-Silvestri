using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CajaNegocio
    {
        public static SgPymeBaseEntities db = new SgPymeBaseEntities();

        public bool ExisteCajaAnteriorSinCerrar()
        {
            var ultimaCaja = ObtenerUltimaCaja();

            if (ultimaCaja == null)
                return false;

            bool esCajaDeOtroDia = ultimaCaja.FechaApertura.Date < DateTime.Now.Date;
            bool noEstaCerrada = ultimaCaja.FechaCierre == null;

            return esCajaDeOtroDia && noEstaCerrada;
        }

        public bool NuevaCajaDiaria(CajasDiarias caja)
        {
            try
            {
                db.CajasDiarias.Add(caja);
                db.SaveChanges();
                return true;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public CajasDiarias ObtenerUltimaCaja()
        { 
            return db.CajasDiarias.OrderByDescending(c => c.FechaApertura).FirstOrDefault();

        }

        public CajasDiarias ObtenerCajaActual()
        {
            try
            {
                DateTime hoy = DateTime.Today;
                DateTime mañana = hoy.AddDays(1);

                CajasDiarias caja = db.CajasDiarias
                    .Where(c => c.FechaApertura >= hoy && c.FechaApertura < mañana && c.FechaCierre == null)
                    .FirstOrDefault();
                return caja;
                //return db.CajasDiarias.Where(c => c.FechaApertura.Date == DateTime.Now.Date && c.FechaCierre == null).FirstOrDefault();
            }
            catch (Exception ex)
            {

                throw ex;
            }
            
        }

        public ResultadoOperacion GuardarEgreso(CajasEgresos cajasEgresos)
        {
            ResultadoOperacion resultado = new ResultadoOperacion();

            try
            {
                cajasEgresos.Fecha = DateTime.Now;
                cajasEgresos.Usuario = 1;

                db.CajasEgresos.Add(cajasEgresos);
                db.SaveChanges();

                resultado.EsExitoso = true;
                resultado.Mensaje = "Egreso guardado correctamente.";
            }
            catch (Exception ex)
            {
                resultado.EsExitoso = false;
                resultado.Mensaje = "Ocurrió un error al guardar: " + ex.Message;
            }

            return resultado;
        }

        public ResultadoOperacion EditarMontoCajaDiaria(CajasDiarias cajasDiarias)
        {
            ResultadoOperacion resultado = new ResultadoOperacion();
            try
            {
                CajasDiarias getCaja = new CajasDiarias();
                getCaja = db.CajasDiarias.OrderByDescending(c => c.IdCajaDiaria == cajasDiarias.IdCajaDiaria).FirstOrDefault();

                getCaja.MontoFinal = cajasDiarias.MontoFinal;

                db.CajasDiarias.Add(getCaja);
                db.SaveChanges();
                resultado.EsExitoso = true;
                resultado.Mensaje = "Edición guardado correctamente.";
            }
            catch (Exception ex) 
            {
                resultado.EsExitoso = false;
                resultado.Mensaje = "Ocurrió un error al editar caja: " + ex.Message;
            }
            return resultado;
        }
    }
}
