using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace AlgFloydSteinberg
{
    public class AlghoritmAsm : Alghoritm
    {
        [DllImport("../../../../x64/Debug/AlgFloydSteinbergAsm.dll")]
        public static extern unsafe int AlghoritmCalculator(byte* arrayPointer, int numberOfBits, int width, int height);

        //wywołanie dll
        public override unsafe void ConvertImage(ref byte[] array, int numberOfBits, int width, int height)
        {
            fixed (byte* arrayPointer = array)
            {
                AlghoritmCalculator(arrayPointer, numberOfBits, width, height);
            }
        }
    }
}