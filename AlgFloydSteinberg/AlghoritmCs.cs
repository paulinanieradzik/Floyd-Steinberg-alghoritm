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
        private readonly Dithering dithering;

        public AlghoritmCs()
        {
            dithering = new Dithering();
        }

        public override void ConvertImage(ref byte[] array, int numberOfBits, int width, int height)
        {
            dithering.AlghoritmCalculator(ref array, numberOfBits, width, height);
        }

        public override string DisplayTime()
        {
            return dithering.DisplayTime();
        }
    }
}