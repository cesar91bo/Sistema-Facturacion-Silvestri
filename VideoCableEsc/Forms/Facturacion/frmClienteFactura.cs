using CapaEntidades;
using CapaNegocio;
using Spire.Pdf.HtmlConverter;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VideoCableEsc.Forms.Facturacion
{
    public partial class frmClienteFactura : Form
    {
        private Button currentButton;
        private Random random;
        private int tempIndex;
        private Form activeForm;
        List<VistaClientes> clis;
        public frmClienteFactura()
        {
            InitializeComponent();
        }

        #region Abrir Form hijo
        public void OpenChildForm(Form childForm, object btnSender)
        {
            frmPrincipal principal = Application.OpenForms["frmPrincipal"] as frmPrincipal;
            if (principal != null)
            {
                if (activeForm != null)
                {
                    activeForm.Close();
                }

                activeForm = childForm;
                childForm.TopLevel = false;
                childForm.FormBorderStyle = FormBorderStyle.None;
                childForm.Dock = DockStyle.Fill;
                principal.panelDesktop.Controls.Add(childForm);
                principal.panelDesktop.Tag = childForm;
                childForm.BringToFront();
                childForm.Show();
                principal.lblTittle.Text = childForm.Text;
            }


        }
        #endregion

        private void frmClienteFactura_Load(object sender, EventArgs e)
        {
            var dt = new DataTable();
            dt.Columns.Add("IdBusqueda");
            dt.Columns.Add("Descripcion");
            dt.Rows.Add("Cliente", "Cliente");

            CrearColListFecha();
            LLenarListaCliente(true);
        }

        private void CrearColListFecha()
        {
            try
            {
                listCliente.Columns.Add("Id Cliente", 70, HorizontalAlignment.Left);
                listCliente.Columns.Add("Cliente", 300, HorizontalAlignment.Left);
                listCliente.Columns.Add("Dirección", 300, HorizontalAlignment.Left);
                listCliente.Columns.Add("Estado", 100, HorizontalAlignment.Left);

            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        private void btnConsultarFacturas_Click(object sender, EventArgs e)
        {
            string nombreCliente = "";
            int idCliente = 0;
            if (listCliente.SelectedItems.Count > 0)
            {
                // Obtiene el primer ítem seleccionado
                ListViewItem itemSeleccionado = listCliente.SelectedItems[0];

                // Obtiene el valor de la columna "Cliente" (índice 1)
                nombreCliente = itemSeleccionado.SubItems[1].Text;
                idCliente = Convert.ToInt32(itemSeleccionado.SubItems[0].Text);
                OpenChildForm(new frmConsFactura(nombreCliente, idCliente), sender);
            }
            else
            {
                MessageBox.Show("Debe seleccionar un cliente.");
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            try
            {
                LLenarListaCliente(false);

                if (string.IsNullOrWhiteSpace(txtCliente.Text))
                {
                    LLenarListaCliente(true);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void LLenarListaCliente(bool _siload)
        {
            try
            {
                listCliente.Items.Clear();

                if (_siload)
                {
                    var cliNegocio = new ClienteNegocio();
                    clis = cliNegocio.ObtenerClientesTotales();
                }
                else { clis = BuscarCli(); }

                if (clis == null) { return; }

                foreach (VistaClientes cli in clis)
                {
                    var item = new ListViewItem
                    {
                        Tag = cli.NroCliente.ToString(),
                        Text = cli.NroCliente.ToString()
                    };
                    item.SubItems.Add(cli.ApellidoyNombre.ToString());
                    item.SubItems.Add(cli.Direccion.ToString());
                    item.SubItems.Add(cli.Estado.ToString());
                    if (cli.Estado.ToString() == "Baja" || (cli.Estado.ToString() == "Suspendido")) { item.ForeColor = Color.Red; }

                    listCliente.Items.Add(item);
                }
                listCliente.Focus();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private List<VistaClientes> BuscarCli()
        {
            try
            {
                if (txtCliente.Text == "") { LLenarListaCliente(true); }
                else
                {
                    var cliNegocio = new ClienteNegocio();
                    if (txtCliente.Text != "")
                    {
                        return cliNegocio.ObtenerListClientesPorNomyApTotal(txtCliente.Text);
                    }
                }
                return null;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void listCliente_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            string nombreCliente = "";
            int idCliente = 0;
            if (listCliente.SelectedItems.Count > 0)
            {
                // Obtiene el primer ítem seleccionado
                ListViewItem itemSeleccionado = listCliente.SelectedItems[0];

                // Obtiene el valor de la columna "Cliente" (índice 1)
                nombreCliente = itemSeleccionado.SubItems[1].Text;
                idCliente = Convert.ToInt32(itemSeleccionado.SubItems[0].Text);
                OpenChildForm(new frmConsFactura(nombreCliente, idCliente), sender);
            }
            else
            {
                MessageBox.Show("Debe seleccionar un cliente.");
            }
        }
    }
}
