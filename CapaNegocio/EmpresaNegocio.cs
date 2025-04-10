using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class EmpresaNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();

        public Empresa GetEmpresa()
        {

            return db.Empresa.First();
        }

    }
}
