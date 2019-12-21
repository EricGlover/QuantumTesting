namespace BellState {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation Set(desired : Result, q1 : Qubit) : Unit 
    {
        if (desired != M(q1)) {
            X(q1);
        }
    }
    operation TestBellState(count : Int, initial : Result) : (Int, Int, Int)
    {
        mutable numOnes = 0;    // these just serve to keep track of our results 
        mutable agree = 0;

        // in Q# you initialize Qubits like you would a resource in C# (in a using statement)
        // q0 will be set to |0>, as will q1
        using ((q0, q1) = (Qubit(), Qubit())) {

            // run this code block count # of times
            for (test in 1..count) {
                // set is defined elsewhere but will set a qubit to |0> or |1> 
                // note the special keyword Zero and One for |0> and |1>
                Set(initial, q0);
                Set(Zero, q1);

                // now we come to the Hadamard Gate 
                // this is equivalent to rotating our qubit 90 degrees which in
                // the case where q0 is |0> or |1> will set q0 to 
                // q0 =  1/sqrt(2) |0> + 1/sqrt(2) |1>
                // if you square the coefficients at the front you get the probability 
                // that when you measure q0 you'll get |0> or |1> 
                H(q0);         
                // the equation for both q0 and q1 is called the tensor product 
                // which is important because we're about to entangle them 
                // q0 X q1 = ( 1/sqrt(2) |0> + 1/sqrt(2) |1> ) X |0>

                // CNOT will entangle our qubits by doing this operation 
                // q0 X q1 = 1/sqrt(2) |00> + 0 |01> + 1/sqrt(2) |10> + 0 |11>
                // after CNOT(q0, q1) = q0 X q1 = 1/sqrt(2) |00> + 0 |01> + 0 * |10> + 1/sqrt(2) |11>
                CNOT(q0, q1);   // 1/sqrt(2) |00> + 1/sqrt(2) |11>      here we just don't write the outcomes with zero probability

                // now we measure q0
                let res = M(q0);

                // Count the number of ones we saw:
                if (res == One) {
                    set numOnes += 1;
                }
                if(M(q1) == res) {      // here we compare our measurements of q0 and q1
                    set agree += 1;
                }
            }

            // set qubits to |0> so when they're released they're in a known state
            Set(Zero, q0);
            Set(Zero, q1);
        }

        // Return number of times we saw a |0> and number of times we saw a |1>
        return (count-numOnes, numOnes, agree);
    }
}
