using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class EstadoNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();

        public List<Estados> GetAll() {
            return db.Estados.ToList();
        }



    }
}
