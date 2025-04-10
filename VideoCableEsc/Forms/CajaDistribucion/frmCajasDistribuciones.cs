using CapaEntidades;
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

namespace VideoCableEsc.Forms.CajaDistribucion
{
    public partial class frmCajasDistribuciones : Form
    {

        List<VistaCajaDistribuciones> cajas;

        public frmCajasDistribuciones()
        {
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void frmCajasDistribuciones_Load(object sender, EventArgs e)
        {
            try
            {
                var dt = new DataTable();
                dt.Columns.Add("IdBusqueda");
                dt.Columns.Add("Descripcion");
                dt.Rows.Add("CajaDistribucionId", "IdCajaDistribuciones");
                dt.Rows.Add("Descipcion", "Descripción");
                //dt.Rows.Add("FechaUltimaModificacion", "Fecha de Modificación");

                CrearColListCajasDistribuciones();
                LLenarListaCajas(true);

            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        private void CrearColListCajasDistribuciones()
        {
            try
            {
                listCD.Columns.Add("Id Caja Distribuciones", 70, HorizontalAlignment.Left);
                listCD.Columns.Add("Descripción", 250, HorizontalAlignment.Left);
                listCD.Columns.Add("Dirección", 250, HorizontalAlignment.Left);
                listCD.Columns.Add("Fecha de Modificación", 80, HorizontalAlignment.Left);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void LLenarListaCajas(bool _siload)
        {
            try
            {
                listCD.Items.Clear();

                if (_siload)
                {
                    var CDNegocio = new CajasDistribucionesNegocio();
                    cajas = CDNegocio.GetVistaCajaDistribuciones();
                }
                else { cajas = BuscarCaja(); }

                if (cajas == null) { return; }

                foreach (VistaCajaDistribuciones caja in cajas)
                {
                    var item = new ListViewItem
                    {
                        Tag = caja.CajaDistribucionId.ToString(),
                        Text = caja.CajaDistribucionId.ToString()
                    };
                    item.SubItems.Add(caja.Descipcion.ToString());
                    item.SubItems.Add(caja.Direccion);
                    item.SubItems.Add(caja.FechaUltimaModificacion.ToString());
                    listCD.Items.Add(item);
                }
                listCD.Focus();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private List<VistaCajaDistribuciones> BuscarCaja()
        {
            try
            {
                if (txtCaja.Text == "") { LLenarListaCajas(true); }
                else
                {
                    var CDNegocio = new CajasDistribucionesNegocio();
                    return CDNegocio.ObtenerListCajasPorNom(txtCaja.Text);
                }
                return null;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void CrearCajaDistribucion_Click(object sender, EventArgs e)
        {
            var frm = new frmCrearCajaDistribucion { Accion = "ALTA" };
            frm.ShowDialog();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            try
            {
                if (listCD.SelectedItems.Count > 0)
                {
                    if (Users.Rol != TiposUsers.Administrador) return;
                    var frmc = new frmCrearCajaDistribucion { Accion = "MOD", NroCaja = Convert.ToInt32(listCD.SelectedItems[0].Tag) };
                    frmc.ShowDialog();
                    LLenarListaCajas(true);
                }
                else { MessageBox.Show("No se puede editar la Caja", "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation); }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            try
            {
                if (listCD.SelectedItems.Count > 0)
                {
                    if (Users.Rol != TiposUsers.Administrador) return;

                    var CDNegocio = new CajasDistribucionesNegocio();

                    if (CDNegocio.Delete(Convert.ToInt32(listCD.SelectedItems[0].Tag)))
                    {
                        MessageBox.Show("La caja se dio de baja correctamente." + Environment.NewLine +
                                "Caja de Distribición Nro: " + listCD.SelectedItems[0].Tag, "SE DIO DE BAJA CORRECTAMENTE", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    else
                    {
                        MessageBox.Show("No se puede dar de baja la caja", "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    };

                    LLenarListaCajas(true);
                }
                else { MessageBox.Show("No se selecciónó ninguna Caja", "ERROR DE SELECCIÓN", MessageBoxButtons.OK, MessageBoxIcon.Exclamation); }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}
