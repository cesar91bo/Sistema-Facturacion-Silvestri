using CapaNegocio;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc.Forms.Reportes
{
    public partial class FormReportes : Form
    {

        private readonly FacturasVentaNegocio facturasVentaNegocio = new FacturasVentaNegocio();
        public FormReportes()
        {
            InitializeComponent();
        }

        private void FormReportes_Load(object sender, EventArgs e)
        {

            ObtenerCobros();
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            ObtenerCobros();
        }

        private void ObtenerCobros() {
            var cobros = facturasVentaNegocio.ObtenerCobros(calendarFechaDesde.Value, calendarFechaHasta.Value);

            TotalCobrado.Text = cobros.TotalCobrado.ToString("C2");
            totalPendienteCobro.Text = cobros.TotalPendienteCobro.ToString("C2");
            TotalDeclarado.Text = cobros.TotalDeclarado.ToString("C2");
            TotalIva.Text = cobros.TotalIva.ToString("C2");
            TotalOtros.Text = cobros.TotalOtros.ToString("C2");
            Morosos.Text = cobros.MorososMas2Meses.ToString("C2");
            RestoMorosos.Text = cobros.RestoMorosos.ToString("C2");
        }

        
    }
}
