using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using VideoCableEsc.Formularios;
using VideoCableEsc.FormBase;
using VideoCableEsc.Forms.Facturacion;
using VideoCableEsc.Forms.CajaDistribucion;
using VideoCableEsc.Forms.Servicio;
using VideoCableEsc.Forms;
using VideoCableEsc.Forms.Reportes;
using VideoCableEsc.Forms.Cliente;
using VideoCableEsc.Forms.Caja;

namespace VideoCableEsc
{
    public partial class frmPrincipal : Form
    {
        //Fields
        private Button currentButton;
        private Random random;
        private int tempIndex;
        private int cont = 0;
        private Form activeForm;
        //Constructor
        public frmPrincipal()
        {
            InitializeComponent();
            random = new Random();
            //currentButton = new Button();
        }

        #region MoverForm
        [DllImport("user32.dll", EntryPoint = "ReleaseCapture")]
        private extern static void ReleaseCapture();
        [DllImport("user32.dll", EntryPoint = "SendMessage")]
        private static extern bool SendMessage(IntPtr hwnd, int wmsg, int wparam, int lparam);
        private void panelTitleBar_MouseDown(object sender, MouseEventArgs e)
        {
            MoveForm();
        }
        private void pictureBox1_MouseDown(object sender, MouseEventArgs e)
        {
            MoveForm();
        }
        private void MoveForm()
        {
            ReleaseCapture();
            SendMessage(this.Handle, 0x112, 0xf012, 0);
        }
        #endregion

        #region Color de Botón
        private Color SeleccionarTemaColor()
        {
            int index = random.Next(ColorTemas.ColorList.Count);
            while (tempIndex == index)
            {
                index = random.Next(ColorTemas.ColorList.Count);
            }
            tempIndex = index;
            string color = ColorTemas.ColorList[index];
            return ColorTranslator.FromHtml(color);
        }

        private void ActivarBoton(object btnSender)
        {
            if (btnSender != null)
            {
                if (cont>0)
                {
                    if (currentButton != (Button)btnSender)
                    {
                        DesactivarBoton();
                        Color color = SeleccionarTemaColor();
                        currentButton = (Button)btnSender;
                        currentButton.BackColor = color;
                        currentButton.ForeColor = Color.White;
                        currentButton.Font = this.btnIndex.Font = new Font("Microsoft Sans Serif", 12.5F, FontStyle.Regular, GraphicsUnit.Point, ((byte)(0)));
                        panelTitleBar.BackColor = color;
                        panelLogo.BackColor = ColorTemas.ChangeColorBrightness(color, -0.3);
                    }
                }
               
                cont++;
            }
        }

        private void DesactivarBoton()
        {
            foreach (Control botonPrevio in panelMenu.Controls)
            {
                if (botonPrevio.GetType() == typeof(Button))
                {
                    botonPrevio.BackColor = Color.FromArgb(51, 51, 76);
                    botonPrevio.ForeColor = Color.Gainsboro;
                    botonPrevio.Font = this.btnCliente.Font = new Font("Microsoft Sans Serif", 10F, FontStyle.Regular, GraphicsUnit.Point, ((byte)(0)));
                }
                
            }
        }
        #endregion

        #region Boton para minimizar y cerrar
        private void btnClose_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
        private void btnMinimize_Click(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }
        #endregion

        #region Formularios y Submenú
        public void OpenChildForm(Form childForm, object btnSender)
        {
            if (activeForm!= null)
            {
                activeForm.Close();
            }
            ActivarBoton(btnSender);
            activeForm = childForm;
            childForm.TopLevel = false;
            childForm.FormBorderStyle = FormBorderStyle.None;
            childForm.Dock = DockStyle.Fill;
            this.panelDesktop.Controls.Add(childForm);
            this.panelDesktop.Tag = childForm;
            childForm.BringToFront();
            childForm.Show();
            lblTittle.Text = childForm.Text;

        }

        private void OcultarPanelesSubMenu()
        {
            if (pnlSubMenuClientes.Visible == true)
                pnlSubMenuClientes.Visible = false;
            if (pnlSubmenuFact.Visible == true)
                pnlSubmenuFact.Visible = false;
            if (pnlSubMenuReporte.Visible == true)
                pnlSubMenuReporte.Visible = false;
        }

        private void MostrarPanelSubMenu(Panel subMenu)
        {
            if (subMenu.Visible == false)
            {
                OcultarPanelesSubMenu();
                subMenu.Visible = true;
            }
            else
            {
                subMenu.Visible = false;
            }
        }
        #endregion

        private void btnIndex_Click(object sender, EventArgs e)
        {
            OpenChildForm(new frmIndex(), sender);
            OcultarPanelesSubMenu();
        }

        private void btnCliente_Click(object sender, EventArgs e)
        {
            ActivarBoton(sender);
            MostrarPanelSubMenu(pnlSubMenuClientes);
        }

        private void btnServicios_Click(object sender, EventArgs e)
        {
            OpenChildForm(new frmServices(), sender);
            OcultarPanelesSubMenu();
        }

        private void btnCajasDis_Click(object sender, EventArgs e)
        {
            OpenChildForm(new frmCajasDistribuciones(), sender);
            OcultarPanelesSubMenu();
        }

        private void btnFactura_Click(object sender, EventArgs e)
        {
            ActivarBoton(sender);
            MostrarPanelSubMenu(pnlSubmenuFact);
        }

        private void btnSetting_Click(object sender, EventArgs e)
        {           
            OpenChildForm(new frmSettings(), sender);
            OcultarPanelesSubMenu();
        }

        private void horaFecha_Tick(object sender, EventArgs e)
        {
            lblHora.Text = DateTime.Now.ToLongTimeString();
            lblFecha.Text = DateTime.Now.ToLongDateString();
        }

        private void btnFacturaX_Click(object sender, EventArgs e)
        {
            OpenChildForm(new frmGenFacturaPorCliente(), sender);
            OcultarPanelesSubMenu();
        }

        private void btnConsultaFV_Click(object sender, EventArgs e)
        {
            OpenChildForm(new frmClienteFactura(), sender);
            OcultarPanelesSubMenu();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            OpenChildForm(new PruebaReporteFactura(), sender);
            OcultarPanelesSubMenu();
        }

        private void pruebaFactura_Click(object sender, EventArgs e)
        {
            OpenChildForm(new PruebaReporteFactura(), sender);
            OcultarPanelesSubMenu();
        }

        private void Reportes_Click(object sender, EventArgs e)
        {
            ActivarBoton(sender);
            MostrarPanelSubMenu(pnlSubMenuReporte);
        }

        private void btnConsVentas_Click(object sender, EventArgs e)
        {
            OpenChildForm(new FormReportes(), sender);
            OcultarPanelesSubMenu();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            OpenChildForm(new FormPresupuesto(), sender);
            OcultarPanelesSubMenu();
        }

        private void btnFibraOptica_Click(object sender, EventArgs e)
        {
            pnlSubMenuClientes.Visible = false;
            OpenChildForm(new frmFibraOptica(), sender);           
        }

        private void btnVideoCable_Click(object sender, EventArgs e)
        {
            OpenChildForm(new frmVideoCable(), sender);
            OcultarPanelesSubMenu();
        }

        private void btnCajas_Click(object sender, EventArgs e)
        {
            OpenChildForm(new frmCaja(), sender);
            OcultarPanelesSubMenu();
        }
    }
}
