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

namespace VideoCableEsc.Forms.ClienteCajaDistribucionServicioEstado
{
    public partial class frmConsultaClientesCajasDistribucionServiciosEstados : Form
    {

        public int clienteCajaDistribucionServicioId;

        private readonly ClienteCajaDistribucionServicioEstadoNegocio clienteCajaDistribucionServicioEstadoNegocio =
            new ClienteCajaDistribucionServicioEstadoNegocio();
        public frmConsultaClientesCajasDistribucionServiciosEstados()
        {
            InitializeComponent();
        }

        private void frmConsultaClientesCajasDistribucionServiciosEstados_Load(object sender, EventArgs e)
        {
            try
            {

                LLenarListaClientesEstados(true);

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void LLenarListaClientesEstados(bool _siload)
        {
            try
            {
                listClientesEstados.Items.Clear();

                var estadosClientes = clienteCajaDistribucionServicioEstadoNegocio.BuscarEstadosPorClienteId(clienteCajaDistribucionServicioId);

                if (estadosClientes == null) { return; }

                foreach (var cli in estadosClientes)
                {
                    var item = new ListViewItem(cli.ClienteCajaDistribucionServicioEstadoId.ToString());

                    item.SubItems.Add(cli.Descripcion.ToString());
                    item.SubItems.Add(cli.FechaUltimaModificacion.ToShortDateString());
                    if(cli.Observaciones != null) item.SubItems.Add(cli.Observaciones.ToString());
                    listClientesEstados.Items.Add(item);
                }
                listClientesEstados.Focus();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void listClientesEstados_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void btnNuevoClienteEstado_Click(object sender, EventArgs e)
        {
            var frm = new frmNuevoClienteCajaDistribucionServicioEstado { clienteCajaDistribucionServicioId = clienteCajaDistribucionServicioId };
            frm.ShowDialog();
            LLenarListaClientesEstados(true);
        }

    }
}
