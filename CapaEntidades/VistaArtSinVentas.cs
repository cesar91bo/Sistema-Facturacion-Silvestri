//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CapaEntidades
{
    using System;
    using System.Collections.Generic;
    
    public partial class VistaArtSinVentas
    {
        public long IdArticulo { get; set; }
        public string DescCorta { get; set; }
        public string Rubro { get; set; }
        public string SubRubro { get; set; }
        public string LlevarStock { get; set; }
        public double StockActual { get; set; }
        public string UMedida { get; set; }
        public System.DateTime FechaCarga { get; set; }
        public string Dias { get; set; }
        public int DiasInt { get; set; }
        public Nullable<short> IdEmpresa { get; set; }
    }
}
