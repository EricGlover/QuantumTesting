namespace Bell
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    operation Set(desired : Result, q1 : Qubit) : Unit 
    {
        if (desired != M(q1)) {
            X(q1);
        }
    }

    operation SetToBellState(q0 : Qubit, q1 : Qubit) : Unit
    {
        // set both to 0
        Reset(q0);
        Reset(q1);
        H(q0);
        H(q1);
        CNOT(q0, q1);
    }

    operation Rand3() : Int
    {
        mutable number = 0;
        using(q = Qubit()) {
            repeat {
                // generate a number 0 - 3
                // we generate a 2bit number one bit at a time 
                
                H(q);
                if(M(q) == One) {
                    set number = 1;
                }
                Set(Zero, q);
                H(q);
                if(M(q) == One) {
                    set number += 2;
                }
                Reset(q);
            } until (number > 0 and number <= 3);
        }
        return number;
    }

    operation BellTheorem(iterations : Int) : (Int, Int)
    {
        mutable totalAgree = 0;
        mutable totalDisagree = 0;
        for(i in 1..iterations) {
            mutable agree = 0;
            mutable disagree = 0;
            using((alice, bob) = (Qubit(), Qubit())) {
                // alice and bob receive entangled qubit pairs 
                SetToBellState(alice, bob);
                // they both randomly select one of three possible bases 
                // how to rotate our qubits 120 degrees or - 120 degrees ...

                // choose theta 
                let basis2 = PI() * 2.0 / 3.0;
                let basis3 = -1.0 * basis2;
                let choice = Rand3();
                if(choice == 1) {
                    // do nothing 
                } elif (choice == 2) {
                    Rz(basis2, alice);
                } elif (choice == 3) {
                    Rz(basis3, alice);
                }

                // bob chooses basis 
                let bChoice = Rand3();
                if(bChoice == 1) {
                    // do nothing 
                } elif (bChoice == 2) {
                    Rz(basis2, bob);
                } elif (bChoice == 3) {
                    Rz(basis3, bob);
                }
                
                // then they record their measurements
                let a = M(alice);
                let b = M(bob);

                // later they compare to see how often they're measurements agreed
                if(a == Zero and b == Zero) {
                    set agree += 1;
                } elif (a == Zero and b == One) {
                    set disagree += 1;
                } elif (a == One and b == Zero) {
                    set disagree += 1;
                } elif (a == One and b == One) {
                    set agree += 1;
                }

                /// reset qubits 
                Reset(alice);
                Reset(bob);   
            }
            set totalAgree += agree;
            set totalDisagree += disagree;
        }

        return (totalAgree , totalDisagree);
    }
}
