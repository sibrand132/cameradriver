using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Collections;

namespace sterownik_aparat
{
     
    public partial class Form1 : Form
    {
       
        
        public Form1()
        {
            InitializeComponent();
        }

      
        private void button3_Click(object sender, EventArgs e)
        {
           
            System.Diagnostics.Process.Start("jess.bat " , "fuz.clp" );
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            richTextBox1.Clear();
            string wyn = "wyniki.txt";
            string[] lines = System.IO.File.ReadAllLines(wyn);
            foreach (string line in lines)
            {
                richTextBox1.Text += line + Environment.NewLine;
            }

        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            File.Delete("fakty.clp");
          
            StreamWriter sw = new StreamWriter("fakty.clp");
            
            sw.WriteLine("(defglobal ?*zmNatOsw* = " + textBox1.Text + " )");
            sw.WriteLine("(defglobal ?*zmPredPor* = " + textBox2.Text + " )");
            sw.WriteLine("(defglobal ?*zmGlebOstr* = " + textBox3.Text + " )");


            sw.Close();


            

        }


        private void Form1_Load(object sender, EventArgs e)
        {

        }

           
    

        private void button6_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process.Start("jess.bat ", "Dostawcy.clp");
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void label3_Click(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Przedział: 0.0001 - 25000 lx \ngdzie: 0.0001 pochmurne bezksiężycowe nocne niebo, a 25000 światło dzienne\n", "Pomoc",
             MessageBoxButtons.OK);
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Przedział: 0 - 200 km/h", "Pomoc",
                         MessageBoxButtons.OK);
        }

        private void button6_Click_1(object sender, EventArgs e)
        {
            MessageBox.Show("Przedział: -1 - 1 \ngdzie: -1 mała głębia ostrości, a 1 duża głębia ostrości", "Pomoc",
             MessageBoxButtons.OK);
        }
    }
}
