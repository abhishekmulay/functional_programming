import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by Abhishek Mulay on 3/30/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

// Constructor template for Asts:
//      new Asts()
//
// Interpretation:
//    This class has static methods that are used to create different kinds of
//    expressions.

public class Asts {
    // Static factory methods for Def

    // Returns a Def with the given left and right hand sides.
    public static Def def(String lhs, Exp rhs) {
        return new DefImpl(lhs, rhs);
    }

    //-----------------------------------------------------------------------------------------------------------
    // Static factory methods for Exp

    // Returns an ArithmeticExp representing e1 op e2.
    public static ArithmeticExp arithmeticExp(Exp e1, String op, Exp e2) {
        return new ArithmeticExpImpl(e1, op, e2);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Returns a CallExp with the given operator and operand expressions.
    public static CallExp callExp(Exp operator, List<Exp> operands) {
        return new CallExpImpl(operator, operands);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Returns a ConstantExp with the given value.
    public static ConstantExp constantExp(ExpVal value) {
        return new ConstantExpImpl(value);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Returns an IdentifierExp with the given identifier name.
    public static IdentifierExp identifierExp(String id) {
        return new IdentifierExpImpl(id);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Returns an IfExp with the given components.
    public static IfExp ifExp(Exp testPart, Exp thenPart, Exp elsePart) {
        return new IfExpImpl(testPart, thenPart, elsePart);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Returns a LambdaExp with the given formals and body.
    public static LambdaExp lambdaExp(List<String> formals, Exp body) {
        return new LambdaExpImpl(formals, body);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Static factory methods for ExpVal

    // Returns a value encapsulating the given boolean.
    public static ExpVal expVal(boolean b) {
        return new ExpValBoolean(b);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Returns a value encapsulating the given (long) integer.
    public static ExpVal expVal(long n) {
        return new ExpValInteger(n);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Returns a value encapsulating the given lambda expression environment.
    public static FunVal expVal(LambdaExp exp, Map<String, ExpVal> env) {
        return new FunValImpl(exp, env);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Static methods for creating short lists
    public static <X> List<X> list(X x1) {
        ArrayList<X> list = new ArrayList<>();
        list.add(x1);
        return list;
    }

    //-----------------------------------------------------------------------------------------------------------
    public static <X> List<X> list(X x1, X x2) {
        ArrayList<X> list = new ArrayList<>();
        list.add(x1);
        list.add(x2);
        return list;
    }

    //-----------------------------------------------------------------------------------------------------------
    public static <X> List<X> list(X x1, X x2, X x3) {
        ArrayList<X> list = new ArrayList<>();
        list.add(x1);
        list.add(x2);
        list.add(x3);
        return list;
    }

    //-----------------------------------------------------------------------------------------------------------
    public static <X> List<X> list(X x1, X x2, X x3, X x4) {
        ArrayList<X> list = new ArrayList<>();
        list.add(x1);
        list.add(x2);
        list.add(x3);
        list.add(x4);
        return list;
    }
    //-----------------------------------------------------------------------------------------------------------
}
