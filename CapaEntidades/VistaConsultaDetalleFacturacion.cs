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
    
    public partial class VistaConsultaDetalleFacturacion
    {
        public int IdFacturaVenta { get; set; }
        public long IdFacturaVentaDetalle { get; set; }
        public string NroFactura { get; set; }
        public System.DateTime FechaEmision { get; set; }
        public string DescCorta { get; set; }
        public Nullable<float> PrecioUnitario { get; set; }
        public Nullable<decimal> Cantidad { get; set; }
        public float PorcentajeIVA { get; set; }
        public Nullable<float> TotalArt { get; set; }
        public int NroCliente { get; set; }
        public string ApellidoyNombre { get; set; }
        public short IdEmpresa { get; set; }
    }
}
