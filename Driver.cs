using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;
using BellState;

namespace Bell
{
    class Driver
    {
        static void Main(string[] args)
        {
            var runBellsTheorem = true;
            var runBellStateTest = true;
            if(runBellStateTest) {
                System.Console.WriteLine("Running Bell State Test.");
                using (var qsim = new QuantumSimulator())
                {
                    int trials = 1000;
                    //Try initial values
                    Result[] initials = new Result[] { Result.Zero, Result.One };
                    foreach (Result initial in initials)
                    {
                        var res = TestBellState.Run(qsim, trials, initial).Result;
                        var (numZeros, numOnes, agree) = res;
                        System.Console.WriteLine($"Init:{initial,-4} 0s={numZeros,-4} 1s={numOnes,-4}, q0 == q1 = {agree, -4}");
                    }
                }
                System.Console.WriteLine("===================");
            }

            if(runBellsTheorem) {
                System.Console.WriteLine("Running Bell's Theorem.");
                using (var qsim = new QuantumSimulator())
                {
                    int trials = 10000;
                    // bell's theorem 
                    var res = BellTheorem.Run(qsim, trials).Result;
                    var (agree, disagree) = res;
                    System.Console.WriteLine($"Agree : {agree}, disagree {disagree}");
                }
                System.Console.WriteLine("===================");
            }
            System.Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
        }
    }
}