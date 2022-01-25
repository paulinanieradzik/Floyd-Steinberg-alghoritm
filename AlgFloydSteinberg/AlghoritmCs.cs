using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AlgFloydSteingergCs;

namespace AlgFloydSteinberg
{
    public class AlghoritmCs : Alghoritm
    {
        //wywołanie dll
        public override void ConvertImage(ref byte[] array, int numberOfBits, int width, int height)
        {
            Dithering dithering = new Dithering();
            dithering.AlghoritmCalculator(ref array, numberOfBits, width, height);
        }
    }
}