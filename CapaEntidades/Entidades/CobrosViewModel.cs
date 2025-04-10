using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaEntidades.Entidades
{
    public class CobrosViewModel
    {
        public decimal TotalCobrado { get; set; }

        public decimal TotalPendienteCobro { get; set; }

        public decimal TotalIva { get; set; }

        public decimal TotalDeclarado { get; set; }

        public decimal TotalOtros { get; set; }
        public decimal MorososMas2Meses { get; set; }
        public decimal RestoMorosos { get; set; }
    }
}
