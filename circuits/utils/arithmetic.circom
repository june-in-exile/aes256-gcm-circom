pragma circom 2.2.2;

include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/comparators.circom";

/**
 * Example: Integer division with remainder
 *  signal quotient, remainder;
 *  (quotient,remainder) <== Divide(8,8)(17,5);
 *  quotient === 3;
 *  remainder === 2;
 */
template Divide() {
    signal input dividend;
    signal input divisor;
    signal output quotient;
    signal output remainder;

    quotient <-- dividend \ divisor;
    remainder <-- dividend % divisor;
    dividend === quotient * divisor + remainder;
}

/**
* @param in - The input number to check parity for
* @return out - The result: 0 if even, 1 if odd
* 
* Example:
*  signal parity <== Mod2()(7);   // Returns 1 (odd)
*  signal parity <== Mod2()(8);   // Returns 0 (even)
*/
template Mod2() {
    signal input in;
    signal output {bit} out;
    
    signal quotient;
    
    (quotient, out) <== Divide()(in, 2);
    
    out * (out - 1) === 0;
}