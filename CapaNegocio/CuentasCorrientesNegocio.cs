using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CuentasCorrientesNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();
        public VistaCtaCteClientes ObtenerVistaCtaCtexIdCliente(Int32 idcliente, Int16 IdEmp)
        {
            return db.VistaCtaCteClientes.SingleOrDefault(c => c.NroCliente == idcliente && c.IdEmpresa == IdEmp);
        }
    }
}
