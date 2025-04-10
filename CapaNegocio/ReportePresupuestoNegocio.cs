using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class ReportePresupuestoNegocio
    {
        public static SgPymeBaseEntities db = new SgPymeBaseEntities();

        public int NuevoRepPres(ReportePresupuesto repPres)
        {
            try
            {
                AgregarReportePres(repPres);
                Grabar();
                return repPres.IdReporte;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool EliminarRegistros()
        {
            var reportesPresupuesto = db.ReportePresupuesto.ToList();
            if (reportesPresupuesto.Count > 0)
            {
                db.ReportePresupuesto.RemoveRange(reportesPresupuesto);
                Grabar();
            }
            return true;
        }

        private void AgregarReportePres(ReportePresupuesto repPres)
        {
            db.ReportePresupuesto.Add(repPres);
        }

        private void Grabar()
        {
            db.SaveChanges();
        }
    }
}
