// Returns the alternating sum of the first n squares, computed ITERS times.
//
// Result is
//
//     n*n - (n-1)*(n-1) + (n-2)*(n-2) - (n-3)*(n-3) + ...
//
// Usage:
//
//     java Sumsq2 N ITERS

class Sumsq2 {

    public static void main(String[] args) {
        long n = Long.parseLong(args[0]);
        long iters = Long.parseLong(args[1]);
        System.out.println(mainLoop(n, iters));
    }

    // Modify this method to use loop syntax instead of tail recursion.
    static long mainLoop(long n, long iters) {
        for (long iteration = iters; iteration >= 0; iteration--) {
            if (iteration == 0) {
                return 0 - 1;
            }

            if (iteration == 1) {
                return sumSquares(n);

            } else {
                sumSquares(n);
            }
        }
        return -1;
    }

    // Returns alternating sum of the first n squares.
    static long sumSquares(long n) {
        long result = 0;
        for (long iteration = 0; iteration < n; iteration++) {
            // even
            if (iteration % 2 == 0) {
                result += (n - iteration) * (n - iteration);
            }
            // odd
            else {
                result -= (n - iteration) * (n - iteration);
            }
        }
        return result;
    }
}
