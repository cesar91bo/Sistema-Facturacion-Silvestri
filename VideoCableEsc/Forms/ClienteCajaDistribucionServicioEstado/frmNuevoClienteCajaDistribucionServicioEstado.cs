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

namespace VideoCableEsc.Forms.ClienteCajaDistribucionServicioEstado
{
    public partial class frmNuevoClienteCajaDistribucionServicioEstado : Form
    {
        public int clienteCajaDistribucionServicioId;

        private readonly EstadoNegocio estadoNegocio = new EstadoNegocio();
        private readonly ClienteCajaDistribucionServicioEstadoNegocio clienteCajaDistribucionServicioEstadoNegocio = new ClienteCajaDistribucionServicioEstadoNegocio();
        public frmNuevoClienteCajaDistribucionServicioEstado()
        {
            InitializeComponent();
        }

        private void frmNuevoClienteCajaDistribucionServicioEstado_Load(object sender, EventArgs e)
        {
            cmbEstado.DataSource = estadoNegocio.GetAll();
            cmbEstado.DisplayMember = "Descripcion";
            cmbEstado.ValueMember = "EstadoId";
        }


        private void btnGuardarClienteEstado_Click(object sender, EventArgs e)
        {
            try
            {
                string mensaje;

                var nuevoEstado = clienteCajaDistribucionServicioEstadoNegocio.Create(new ClientesCajasDistribucionesServiciosEstados
                {

                    EstadoId = Convert.ToInt32(cmbEstado.SelectedValue.ToString()),
                    Observaciones = txtObservaciones.Text,
                    FechaUltimaModificacion = DateTime.Now,
                    UsuarioUltimaModificacion = 1,
                    ClienteCajaDistribucionServicioId = clienteCajaDistribucionServicioId
                }, out mensaje);

                if (nuevoEstado.ClienteCajaDistribucionServicioEstadoId > 0)
                {
                    MessageBox.Show("El estado se ingresó correctamente." + Environment.NewLine, "ALTA CORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);

                    this.Close();

                    DialogResult = DialogResult.OK;
                }
                else
                {
                    MessageBox.Show(mensaje + Environment.NewLine, "ALTA INCORRECTA", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    this.Close();
                }

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }


    }
}
