﻿using CapaEntidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class FacturasElectronicasNegocio
    {
        private readonly SgPymeBaseEntities db = new SgPymeBaseEntities();

        public FacturasElectronicas GetFacturaElectronicaByFacturaVentaId(int idFacturaVenta)
        {

            return db.FacturasElectronicas.FirstOrDefault(x => x.IdFacturaVenta == idFacturaVenta);
        }

    }
}
