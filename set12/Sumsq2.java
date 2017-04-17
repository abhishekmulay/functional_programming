///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Returns the alternating sum of the first n squares, computed ITERS times.
//
// Result is
//
//     n*n - (n-1)*(n-1) + (n-2)*(n-2) - (n-3)*(n-3) + ...
//
// Usage:
//
//     java Sumsq N ITERS

class Sumsq2 {

    public static void main(String[] args) {
        long n = Long.parseLong(args[0]);
        long iters = Long.parseLong(args[1]);
        System.out.println(mainLoop(n, iters));
    }

    ////////////////////////////////////////////////////////////////////////////////////////////
    //          This method now uses loop syntax instead of tail recursion.                  //
    //////////////////////////////////////////////////////////////////////////////////////////

    // given: number n that represents number of terms in equation and number that represents number of iterations
    // returns: the alternating sum of the first n squares, computed ITERS times.
    // where: Following equation gives value of mainLoop(n) for any n > 0
    //
    //     n*n - (n-1)*(n-1) + (n-2)*(n-2) - (n-3)*(n-3) + ...
    // Pattern: Functional visitor pattern
    static long mainLoop(long n, long iters) {
        for (long iteration = iters; iteration >= 0; iteration--) {
            if (iteration == 0) {
                return 0 - 1;

            } else if (iteration == 1) {
                return sumSquares(n);

            } else {
                sumSquares(n);
            }
        }
        return -1;
    }

    // Returns alternating sum of the first n squares.
    static long sumSquares(long n) {
        return sumSquaresLoop(n, 0);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////
    //  Following methods have been modified to use loop syntax instead of tail recursion.  //
    /////////////////////////////////////////////////////////////////////////////////////////

    // Returns alternating sum of the first n+1 squares, plus sum.
    static long sumSquaresLoop(long n, long sum) {
        for (long index = n; index > 0; index -= 2) {
            sum = sum + index * index;
        }
        return sumSquaresLoop2(n - 1, sum);
    }

    // Returns alternating sum of the first n+1 squares, minus (n+1)^2, plus sum.
    static long sumSquaresLoop2(long n, long sum) {
        for (long index = n; index > 0; index -= 2) {
            sum = sum - index * index;
        }
        return sum;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////