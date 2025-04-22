using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
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

        public ResultadoOperacion EditarMontoCajaDiaria(decimal monto, int idCajaDiaria)
        {
            ResultadoOperacion resultado = new ResultadoOperacion();
            try
            {
                CajasDiarias getCaja = new CajasDiarias();
                getCaja = db.CajasDiarias.OrderByDescending(c => c.IdCajaDiaria == idCajaDiaria).FirstOrDefault();

                if (getCaja != null)
                {
                    getCaja.MontoFinal = getCaja.MontoFinal + monto;

                    db.SaveChanges();
                    resultado.EsExitoso = true;
                    resultado.Mensaje = "Edición guardado correctamente.";
                }
                else 
                { 
                    resultado.EsExitoso=false;
                    resultado.Mensaje = "No se encontró la caja a editar";
                }
            }
            catch (Exception ex) 
            {
                resultado.EsExitoso = false;
                resultado.Mensaje = "Ocurrió un error al editar caja: " + ex.Message;
            }
            return resultado;
        }

        public ResultadoOperacion CerrarCajaDiaria(CajasDiarias cajaDiaria)
        {
            ResultadoOperacion resultado = new ResultadoOperacion();
            try
            {
                CajasDiarias getCaja = new CajasDiarias();
                getCaja = db.CajasDiarias.OrderByDescending(c => c.IdCajaDiaria == cajaDiaria.IdCajaDiaria).FirstOrDefault();

                if (getCaja != null)
                {
                    getCaja.MontoFinal = getCaja.MontoFinal + cajaDiaria.MontoFinal;
                    getCaja.Estado = cajaDiaria.Estado;
                    getCaja.FechaCierre = cajaDiaria.FechaCierre;
                    getCaja.Observaciones = cajaDiaria.Observaciones;

                    db.SaveChanges();
                    resultado.Mensaje = "Se cerró la caja correctamente.";
                }
                else
                {
                    resultado.EsExitoso = false;
                    resultado.Mensaje = "No se encontró la caja a cerrar.";
                }
            }
            catch (Exception ex)
            {

                resultado.EsExitoso = false;
                resultado.Mensaje = "Ocurrió un error al cerrar caja: " + ex.Message;
            }

            return resultado;
        }

        public List<CajasEgresos> ObtenerCajaEgresoPorFecha(DateTime fechaApertura)
        {
            try
            {
                return db.CajasEgresos
               .Where(c => c.Fecha.Date == fechaApertura.Date)
               .ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
