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
    
    public partial class FacturasCompraDetalle
    {
        public long IdFacturaCompraDetalle { get; set; }
        public int IdFacturaCompra { get; set; }
        public Nullable<long> IdArticulo { get; set; }
        public string Articulo { get; set; }
        public string UMedida { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal PorcentajeBonif { get; set; }
        public decimal TotalArt { get; set; }
        public bool DesdeRemito { get; set; }
        public byte IdTipoIva { get; set; }
        public string UsrAcceso { get; set; }
        public System.DateTime FechaAcceso { get; set; }
        public Nullable<bool> MueveStock { get; set; }
        public decimal PorcentajeBonif2 { get; set; }
        public decimal PorcentajeBonif3 { get; set; }
        public decimal PorcentajeBonif4 { get; set; }
        public decimal PorcentajeBonif5 { get; set; }
    
        public virtual Articulos Articulos { get; set; }
        public virtual FacturasCompra FacturasCompra { get; set; }
        public virtual TiposIva TiposIva { get; set; }
    }
}
