namespace VideoCableEsc.Forms.Reportes
{
    partial class FormReportes
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FormReportes));
            this.label1 = new System.Windows.Forms.Label();
            this.TotalCobrado = new System.Windows.Forms.Label();
            this.totalPendienteCobro = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.TotalDeclarado = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.TotalOtros = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.TotalIva = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnBuscar = new System.Windows.Forms.Button();
            this.calendarFechaHasta = new System.Windows.Forms.DateTimePicker();
            this.calendarFechaDesde = new System.Windows.Forms.DateTimePicker();
            this.label5 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.RestoMorosos = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.Morosos = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.LimeGreen;
            this.label1.Location = new System.Drawing.Point(17, 299);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(154, 26);
            this.label1.TabIndex = 0;
            this.label1.Text = "Total Cobrado:";
            // 
            // TotalCobrado
            // 
            this.TotalCobrado.AutoSize = true;
            this.TotalCobrado.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.TotalCobrado.ForeColor = System.Drawing.Color.LimeGreen;
            this.TotalCobrado.Location = new System.Drawing.Point(193, 299);
            this.TotalCobrado.Name = "TotalCobrado";
            this.TotalCobrado.Size = new System.Drawing.Size(66, 26);
            this.TotalCobrado.TabIndex = 1;
            this.TotalCobrado.Text = "$0,00";
            // 
            // totalPendienteCobro
            // 
            this.totalPendienteCobro.AutoSize = true;
            this.totalPendienteCobro.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.totalPendienteCobro.ForeColor = System.Drawing.Color.Red;
            this.totalPendienteCobro.Location = new System.Drawing.Point(635, 299);
            this.totalPendienteCobro.Name = "totalPendienteCobro";
            this.totalPendienteCobro.Size = new System.Drawing.Size(66, 26);
            this.totalPendienteCobro.TabIndex = 3;
            this.totalPendienteCobro.Text = "$0,00";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.ForeColor = System.Drawing.Color.Red;
            this.label4.Location = new System.Drawing.Point(418, 299);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(211, 26);
            this.label4.TabIndex = 2;
            this.label4.Text = "Pendiente de Cobro:";
            // 
            // TotalDeclarado
            // 
            this.TotalDeclarado.AutoSize = true;
            this.TotalDeclarado.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.TotalDeclarado.ForeColor = System.Drawing.Color.DarkSeaGreen;
            this.TotalDeclarado.Location = new System.Drawing.Point(193, 338);
            this.TotalDeclarado.Name = "TotalDeclarado";
            this.TotalDeclarado.Size = new System.Drawing.Size(66, 26);
            this.TotalDeclarado.TabIndex = 5;
            this.TotalDeclarado.Text = "$0,00";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.ForeColor = System.Drawing.Color.DarkSeaGreen;
            this.label6.Location = new System.Drawing.Point(17, 338);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(170, 26);
            this.label6.TabIndex = 4;
            this.label6.Text = "Total Declarado:";
            // 
            // TotalOtros
            // 
            this.TotalOtros.AutoSize = true;
            this.TotalOtros.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.TotalOtros.ForeColor = System.Drawing.Color.DarkSeaGreen;
            this.TotalOtros.Location = new System.Drawing.Point(193, 404);
            this.TotalOtros.Name = "TotalOtros";
            this.TotalOtros.Size = new System.Drawing.Size(66, 26);
            this.TotalOtros.TabIndex = 7;
            this.TotalOtros.Text = "$0,00";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.ForeColor = System.Drawing.Color.DarkSeaGreen;
            this.label8.Location = new System.Drawing.Point(17, 404);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(124, 26);
            this.label8.TabIndex = 6;
            this.label8.Text = "Total Otros:";
            // 
            // TotalIva
            // 
            this.TotalIva.AutoSize = true;
            this.TotalIva.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.TotalIva.ForeColor = System.Drawing.Color.DarkSeaGreen;
            this.TotalIva.Location = new System.Drawing.Point(193, 373);
            this.TotalIva.Name = "TotalIva";
            this.TotalIva.Size = new System.Drawing.Size(66, 26);
            this.TotalIva.TabIndex = 9;
            this.TotalIva.Text = "$0,00";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.ForeColor = System.Drawing.Color.DarkSeaGreen;
            this.label10.Location = new System.Drawing.Point(17, 373);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(107, 26);
            this.label10.TabIndex = 8;
            this.label10.Text = "Total IVA:";
            // 
            // groupBox1
            // 
            this.groupBox1.BackColor = System.Drawing.SystemColors.ButtonShadow;
            this.groupBox1.Controls.Add(this.btnBuscar);
            this.groupBox1.Controls.Add(this.calendarFechaHasta);
            this.groupBox1.Controls.Add(this.calendarFechaDesde);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox1.Location = new System.Drawing.Point(12, 137);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(776, 131);
            this.groupBox1.TabIndex = 10;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Filtros";
            // 
            // btnBuscar
            // 
            this.btnBuscar.Image = ((System.Drawing.Image)(resources.GetObject("btnBuscar.Image")));
            this.btnBuscar.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft;
            this.btnBuscar.Location = new System.Drawing.Point(10, 95);
            this.btnBuscar.Name = "btnBuscar";
            this.btnBuscar.Size = new System.Drawing.Size(91, 30);
            this.btnBuscar.TabIndex = 50;
            this.btnBuscar.Text = "Buscar";
            this.btnBuscar.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.btnBuscar.UseVisualStyleBackColor = true;
            this.btnBuscar.Click += new System.EventHandler(this.btnBuscar_Click);
            // 
            // calendarFechaHasta
            // 
            this.calendarFechaHasta.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.calendarFechaHasta.Location = new System.Drawing.Point(471, 49);
            this.calendarFechaHasta.Name = "calendarFechaHasta";
            this.calendarFechaHasta.Size = new System.Drawing.Size(105, 26);
            this.calendarFechaHasta.TabIndex = 47;
            // 
            // calendarFechaDesde
            // 
            this.calendarFechaDesde.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.calendarFechaDesde.Location = new System.Drawing.Point(121, 49);
            this.calendarFechaDesde.Name = "calendarFechaDesde";
            this.calendarFechaDesde.Size = new System.Drawing.Size(105, 26);
            this.calendarFechaDesde.TabIndex = 46;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(360, 49);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(105, 20);
            this.label5.TabIndex = 1;
            this.label5.Text = "Fecha Hasta:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 49);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(109, 20);
            this.label2.TabIndex = 0;
            this.label2.Text = "Fecha Desde:";
            // 
            // RestoMorosos
            // 
            this.RestoMorosos.AutoSize = true;
            this.RestoMorosos.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.RestoMorosos.ForeColor = System.Drawing.Color.Coral;
            this.RestoMorosos.Location = new System.Drawing.Point(635, 373);
            this.RestoMorosos.Name = "RestoMorosos";
            this.RestoMorosos.Size = new System.Drawing.Size(66, 26);
            this.RestoMorosos.TabIndex = 14;
            this.RestoMorosos.Text = "$0,00";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.ForeColor = System.Drawing.Color.Coral;
            this.label12.Location = new System.Drawing.Point(418, 373);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(203, 26);
            this.label12.TabIndex = 13;
            this.label12.Text = "Resto Pend. Cobro:";
            // 
            // Morosos
            // 
            this.Morosos.AutoSize = true;
            this.Morosos.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Morosos.ForeColor = System.Drawing.Color.Coral;
            this.Morosos.Location = new System.Drawing.Point(635, 338);
            this.Morosos.Name = "Morosos";
            this.Morosos.Size = new System.Drawing.Size(66, 26);
            this.Morosos.TabIndex = 12;
            this.Morosos.Text = "$0,00";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label11.ForeColor = System.Drawing.Color.Coral;
            this.label11.Location = new System.Drawing.Point(418, 338);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(202, 26);
            this.label11.TabIndex = 11;
            this.label11.Text = "Morosos +2 Meses:";
            // 
            // FormReportes
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.RestoMorosos);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.Morosos);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.TotalIva);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.TotalOtros);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.TotalDeclarado);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.totalPendienteCobro);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.TotalCobrado);
            this.Controls.Add(this.label1);
            this.Name = "FormReportes";
            this.Text = "Reportes";
            this.Load += new System.EventHandler(this.FormReportes_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label TotalCobrado;
        private System.Windows.Forms.Label totalPendienteCobro;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label TotalDeclarado;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label TotalOtros;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label TotalIva;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DateTimePicker calendarFechaHasta;
        private System.Windows.Forms.DateTimePicker calendarFechaDesde;
        private System.Windows.Forms.Button btnBuscar;
        private System.Windows.Forms.Label RestoMorosos;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.Label Morosos;
        private System.Windows.Forms.Label label11;
    }
}