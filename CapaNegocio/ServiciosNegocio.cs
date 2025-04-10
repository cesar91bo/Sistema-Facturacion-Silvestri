using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class ServiciosNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();

        public Servicios GetById(int id)
        {
            return db.Servicios.FirstOrDefault(x => x.ServicioId == id);
        }

        public List<Servicios> GetAll()
        {
            return db.Servicios.ToList();
        }

        public List<Servicios> GetAllActive()
        {
            var servicios = from servicio in GetList()
                            where servicio.Activo.Value == true
                            select servicio;

            return servicios.ToList();
        }

        public List<Servicios> GetList()
        {
            return db.Servicios.ToList();
        }

        public void EditServicio(int servicioId)
        {
            throw new NotImplementedException();
        }
    }
}
