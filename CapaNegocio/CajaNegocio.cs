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
            return false;
        }

        public CajasDiarias ObtenerUltimaCaja()
        {
            return db.CajasDiarias.OrderByDescending(c => c.FechaApertura).FirstOrDefault();

        }
    }
}
