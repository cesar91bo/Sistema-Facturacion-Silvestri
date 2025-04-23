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

        public ResultadoOperacion EditarMontoCajaDiaria(decimal montoTotal, decimal vuelto, int idCajaDiaria)
        {
            ResultadoOperacion resultado = new ResultadoOperacion();
            try
            {
                CajasDiarias getCaja = new CajasDiarias();
                getCaja = db.CajasDiarias.FirstOrDefault(c => c.IdCajaDiaria == idCajaDiaria);

                //List<CajasEgresos> getEgreso = db.CajasEgresos.Where(c => c.IdCajaDiaria == getCaja.IdCajaDiaria).ToList();

                //decimal totalEgresos = 0;

                //if (getEgreso != null)
                //{
                //    totalEgresos += getEgreso.Sum(c => c.Monto);
                //}

                if (getCaja != null)
                {
                    getCaja.MontoFinal = (getCaja.MontoFinal ?? getCaja.MontoInicial) + (montoTotal-vuelto);

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
                    getCaja.MontoFinal = getCaja.MontoFinal;
                    getCaja.Estado = cajaDiaria.Estado;
                    getCaja.FechaCierre = cajaDiaria.FechaCierre;
                    getCaja.Observaciones = cajaDiaria.Observaciones;

                    db.SaveChanges();
                    resultado.Mensaje = "Se cerró la caja correctamente.";
                    resultado.EsExitoso = true;
                }
                else
                {
                    resultado.Mensaje = "No se encontró la caja a cerrar.";
                    resultado.EsExitoso = false;
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
                DateTime desde = fechaApertura.Date;
                DateTime hasta = fechaApertura.Date.AddDays(1);
                return db.CajasEgresos
               .Where(c => c.Fecha >= desde && c.Fecha < hasta)
               .ToList();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public List<CajasDiarias> ObtenerCajas()
        {
            try
            {
                return db.CajasDiarias.ToList();
            }
            catch (Exception ex)
            {

                return new List<CajasDiarias>();
            }
        }

        public List<CajasDiarias> ObtenerCajaPorFecha(DateTime desde, DateTime hasta)
        {
            try
            {
                DateTime fechaDesde = desde.Date;
                DateTime fechaHasta = hasta.Date.AddDays(1);
                return db.CajasDiarias
                    .Where(c => c.FechaApertura >= fechaDesde && c.FechaApertura < fechaHasta)
                    .ToList();
            }
            catch
            {
                return new List<CajasDiarias>();
            }
        }


        public List<CajasEgresos> ObtenerCajaEgresoPorIdCaja(int idCajaDiaria)
        {
            try
            {
                return db.CajasEgresos.Where(c => c.IdCajaDiaria == idCajaDiaria).ToList();
            }
            catch (Exception)
            {

                return new List<CajasEgresos>();
            }
        }
    }
}
