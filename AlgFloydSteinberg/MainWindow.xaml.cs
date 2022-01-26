using System;
using System.Windows;
using System.IO;
using System.Runtime.InteropServices;
using System.Drawing;
using AlgFloydSteingergCs;

namespace AlgFloydSteinberg
{
    public partial class MainWindow : Window
    {
        private Image orginalImage;
        private Image convertedImage;
        private ImageIOHandler imageIOHandler;
        private ExecuteAlghoritm executeAlghoritm;
        private int numberOfBits;

        public MainWindow()
        {
            InitializeComponent();
            WindowStartupLocation = WindowStartupLocation.CenterScreen;
            imageIOHandler = new ImageIOHandler();
            if (File.Exists("./gory.png"))
            {
                orginalImage = new Bitmap("./gory.png");
                convertedImage = new Bitmap("./gory.png");
            }
            executeAlghoritm = new ExecuteAlghoritm();
            radioButtonCs.IsChecked = true;
            executeAlghoritm.SetAlghoritmTypeToCs(true);
            numberOfBits = (int)Slider.Value;
        }

        private void ExecuteAlghoritm(object sender, RoutedEventArgs e)
        {
            if (orginalImage != null)
            {
                convertedImage = executeAlghoritm.Dithering(orginalImage, numberOfBits);
                convertedImageXaml.Source = imageIOHandler.BitmapToImageSource((Bitmap)convertedImage);
                if (radioButtonCs.IsChecked == true)
                {
                    timeCs.Content += " " + executeAlghoritm.DisplayTime() + "ms";
                }
                else
                {
                    timeAsm.Content += " " + executeAlghoritm.DisplayTime() + "ms";
                }
            }
        }

        private void ChooseImage_Click(object sender, RoutedEventArgs e)
        {
            orginalImage = imageIOHandler.OpenImage();
            if (orginalImage != null)
            {
                orginalImageXaml.Source = imageIOHandler.BitmapToImageSource((Bitmap)orginalImage);
                convertedImageXaml.Source = imageIOHandler.BitmapToImageSource((Bitmap)orginalImage);
            }
        }

        private void SaveImage_Click(object sender, RoutedEventArgs e)
        {
            if (convertedImage != null)
            {
                imageIOHandler.SaveImage(convertedImage);
            }
        }

        private void RadioButtonASM_Checked(object sender, RoutedEventArgs e)
        {
            executeAlghoritm.SetAlghoritmTypeToCs(false);
        }

        private void RadioButtonCs_Checked(object sender, RoutedEventArgs e)
        {
            executeAlghoritm.SetAlghoritmTypeToCs(true);
        }

        private void Slider_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            numberOfBits = (int)Slider.Value;
            numberBits.Content = numberOfBits.ToString();
        }
    }
}