using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace sterownik_aparat
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            string path = Application.ExecutablePath;
            path = path.Remove(path.LastIndexOf(@"\"));
            
           Directory.SetCurrentDirectory(path + @"\sterownik_aparat\bin");
          
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}
