import java.util.*;

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

//Constructor template for Tests:
//      new Tests()
//
//Interpretation:
//      This class provides static methods that test various parts of the application.

public class Tests {

    public static Exp constant(long n) {
        return Asts.constantExp(Asts.expVal(n));
    }

    public static Exp id(String s) {
        return Asts.identifierExp(s);
    }

    @SafeVarargs
    public static <T> List<T> list(T... vs) {
        return Arrays.asList(vs);
    }

    //-----------------------------------------------------------------------------------------------------------
    //IfOperations tests
    public static void testIfOperations() {
        Exp two = Asts.constantExp(Asts.expVal(2));
        Exp three = Asts.constantExp(Asts.expVal(3));
        Exp testPart1 = Asts.arithmeticExp(two, ArithmeticExpImpl.EQ, three);
        Exp thenPart1 = Asts.constantExp(Asts.expVal(false));
        Exp elsePart1 = Asts.constantExp(Asts.expVal(true));
        IfExp result1 = Asts.ifExp(testPart1, thenPart1, elsePart1);
        assert result1.isIf() == true : "result should be an IF expression.";
        assert result1.thenPart().value(null).asBoolean() == false :
                " then part should be false, because 2 != 3";

        Exp testPart2 = Asts.arithmeticExp(two, ArithmeticExpImpl.LT, three);
        Exp thenPart2 = Asts.constantExp(Asts.expVal(true));
        Exp elsePart2 = Asts.constantExp(Asts.expVal(false));
        IfExp result2 = Asts.ifExp(testPart2, thenPart2, elsePart2);

        assert result2.isIf() == true : "result should be an IF expression.";
        System.out.println("\nAll IF operation tests passed.");
    }

    //-----------------------------------------------------------------------------------------------------------
    //Arithmetic tests
    public static void testArithmeticOperations() {
        Exp two = Asts.constantExp(Asts.expVal(2));
        Exp three = Asts.constantExp(Asts.expVal(3));
        Exp trueExp = Asts.constantExp(Asts.expVal(true));
        Exp falseExp = Asts.constantExp(Asts.expVal(false));

        Exp twoTimesThree = Asts.arithmeticExp(two, ArithmeticExpImpl.TIMES, three);
        Exp twoPlusThree = Asts.arithmeticExp(two, ArithmeticExpImpl.PLUS, three);
        Exp twoMinusThree = Asts.arithmeticExp(two, ArithmeticExpImpl.MINUS, three);
        Exp threeMinusTwo = Asts.arithmeticExp(three, ArithmeticExpImpl.MINUS, two);
        Exp threeGreaterThanTwo = Asts.arithmeticExp(three, ArithmeticExpImpl.GT, two);
        Exp twoLesserThanThree = Asts.arithmeticExp(two, ArithmeticExpImpl.LT, three);
        Exp twoEqualsTwo = Asts.arithmeticExp(two, ArithmeticExpImpl.EQ, two);
        Exp twoEqualsThree = Asts.arithmeticExp(two, ArithmeticExpImpl.EQ, three);
        Exp trueEqualsTrue = Asts.arithmeticExp(trueExp, ArithmeticExpImpl.EQ, trueExp);
        Exp trueEqualsFalse = Asts.arithmeticExp(trueExp, ArithmeticExpImpl.EQ, falseExp);
        Map<String, ExpVal> DEFAULT_ENV = new HashMap<>();

        assert twoTimesThree.value(DEFAULT_ENV).asInteger() == 6 : " TIMES does not work.";
        assert twoPlusThree.value(DEFAULT_ENV).asInteger() == 5 : " PLUS does not work.";
        assert twoMinusThree.value(DEFAULT_ENV).asInteger() == -1 : " MINUS does not work.";
        assert threeMinusTwo.value(DEFAULT_ENV).asInteger() == 1 : " MINUS does not work.";
        assert threeGreaterThanTwo.value(DEFAULT_ENV).asBoolean() == true : " GT does not work.";
        assert twoLesserThanThree.value(DEFAULT_ENV).asBoolean() == true : " LT does not work.";
        assert twoEqualsTwo.value(DEFAULT_ENV).asBoolean() == true : " EQ does not work.";
        assert twoEqualsThree.value(DEFAULT_ENV).asBoolean() == false : " EQ does not work.";
        assert trueEqualsTrue.value(DEFAULT_ENV).asBoolean() == true : "EQ does not work for boolean";
        assert trueEqualsFalse.value(DEFAULT_ENV).asBoolean() == false : "EQ does not work for boolean";
        System.out.println("\nAll arithmetic operations tests passed.");
    }

    //-----------------------------------------------------------------------------------------------------------
    //Program tests (also coverage for Calls/Lambda/Identifier)
    public static void testProgram() {
        Exp exp1 = Asts.arithmeticExp(Asts.identifierExp("n"), ArithmeticExpImpl.MINUS,
                Asts.constantExp(Asts.expVal(1)));
        Exp call1 = Asts.callExp(Asts.identifierExp("fact"), Asts.list(exp1));

        Exp testPart = Asts.arithmeticExp(Asts.identifierExp("n"), ArithmeticExpImpl.EQ,
                Asts.constantExp(Asts.expVal(0)));
        Exp thenPart = Asts.constantExp(Asts.expVal(1));
        Exp elsePart = Asts.arithmeticExp(Asts.identifierExp("n"), ArithmeticExpImpl.TIMES, call1);

        Def def1 = Asts.def("fact", Asts.lambdaExp(Asts.list("n"), Asts.ifExp(testPart, thenPart, elsePart)));
        ExpVal result = Programs.run(Asts.list(def1), Asts.list(Asts.expVal(5)));

        assert result.asInteger() == 120 : "should be 120";
        System.out.println("\nAll Program operation tests passed.");
    }
    //-----------------------------------------------------------------------------------------------------------
    // test undefined variables
    public static void testUndefined() {
        Set<String> emptySet = new HashSet<>();
        Set<String> undefinedInBad = new HashSet<>();
        undefinedInBad.add("x");
        undefinedInBad.add("z");

        assert Programs.undefined ("church.ps11").equals(emptySet) : "Church has no undefined variables.";
        assert Programs.undefined ("sieve.ps11").equals(emptySet) : "Church has no undefined variables.";
        assert Programs.undefined ("vectors.ps11").equals(emptySet) : "Church has no undefined variables.";
        assert Programs.undefined ("bad.ps11").equals(undefinedInBad) : "x and z should be undefined in bad.ps11";
        System.out.println("\nAll undefined() tests passed.");
    }
    //-----------------------------------------------------------------------------------------------------------
    // test set11 q1
    public static void testProgramMain() {
        String filename = "sieve.ps11";
        String args[] = new String[]{filename, "2", "100"};

        assert (Long)Programs.evaluateProgram(filename, args) == 25 : "should evaluate to 25";
        System.out.println("All Programs.main() tests passed.");

        // test if we can return lambda from function.
        String filenameLambda = "returnFunction.ps11";
        String argsLambda[] = new String[]{filenameLambda, "2", "1"};

        Object result = Programs.evaluateProgram(filenameLambda, argsLambda);
        System.out.println("\nResult of lambda: " + result);

    }

    //-----------------------------------------------------------------------------------------------------------
    // initiate tests
    public static void main(String[] args) {

        // correctness tests for set 10
        PdpExpTests.main(args);
        PdpPgmTests.main(args);

        Tests.testArithmeticOperations();
        Tests.testIfOperations();
        Tests.testProgram();
        Tests.testUndefined();
        Tests.testProgramMain();

        System.out.println("\n\n[Tests] All application tests and correctness tests passed!");
    }
    //-----------------------------------------------------------------------------------------------------------
}
