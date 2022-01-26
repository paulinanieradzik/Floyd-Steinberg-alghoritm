using System;
using System.Collections.Generic;
using System.Linq;
using System.Management;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace AlgFloydSteinberg
{
    public class AlghoritmAsm : Alghoritm
    {
        private int tics;
        private uint currentFrequencyMhz = 0;

        [DllImport("../../../../x64/Release/AlgFloydSteinbergAsm.dll")]
        public static extern unsafe int AlghoritmCalculator(byte* arrayPointer, int numberOfBits, int width, int height);

        public override unsafe void ConvertImage(ref byte[] array, int numberOfBits, int width, int height)
        {
            fixed (byte* arrayPointer = array)
            {
                tics = AlghoritmCalculator(arrayPointer, numberOfBits, width, height);
            }
        }

        public override string DisplayTime()
        {
            ManagementObject managementObject = new ManagementObject("Win32_Processor.DeviceID='CPU0'");
            currentFrequencyMhz = (uint)managementObject["CurrentClockSpeed"];
            return (tics / (float)(currentFrequencyMhz * 1000)).ToString();
        }
    }
}