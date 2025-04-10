using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class FacturasVentaDetalleNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();

        public FacturasVentaDetalle Create(FacturasVentaDetalle model, out string mensaje)
        {
            mensaje = string.Empty;

            try
            {

                db.FacturasVentaDetalle.Add(model);

                db.SaveChanges();

                return model;

            }
            catch (Exception ex)
            {
                mensaje = "Ha ocurrido un error al intentar crear la entidad.";
                throw ex;
            }
        }
    }
}
