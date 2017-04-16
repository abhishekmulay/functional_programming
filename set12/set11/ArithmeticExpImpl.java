import java.util.List;
import java.util.Map;

/**
 * Created by Abhishek Mulay on 3/30/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

// Constructor templates for ArithmeticExpImpl:
//     new ArithmeticExpImpl(Exp, String, Exp)
// Interpretation:
//     This class represents an arithmetic expression, which is comprised of
//     a left hand side expression, an expression on right hand side and an operator
//    which operates on those two expressions.

public class ArithmeticExpImpl extends BaseExp implements ArithmeticExp {

    // constants
    public static final String TIMES = "TIMES";
    public static final String PLUS = "PLUS";
    public static final String MINUS = "MINUS";
    public static final String EQ = "EQ";
    public static final String GT = "GT";
    public static final String LT = "LT";

    // Represents left hand side expression in this arithmetic expression
    private Exp lhs;
    // Represents the operator that operates on
    private String operator;
    // Represents right hand side expression in this arithmetic expression
    private Exp rhs;

    // constructor
    public ArithmeticExpImpl(Exp lhs, String operator, Exp rhs) {
        this.lhs = lhs;
        this.operator = operator;
        this.rhs = rhs;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: True as this object is an ArithmeticExp.
    // Example: (new Asts.arithmeticExp(Asts.constantExp (Asts.expVal (1)),
    //								    "PLUS",
    //									Asts.constantExp (Asts.expVal (2))))
    //			.isArithmetic()
    //   		=> true
    @Override
    public boolean isArithmetic() {
        return true;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: this, as it is already an ArithmeticExp
    //			for this object type
    // Example: (new Asts.arithmeticExp(Asts.constantExp (Asts.expVal (1)),
    //								    "PLUS",
    //									Asts.constantExp (Asts.expVal (2))))
    //			.asArithmetic()
    //		 => 
    //  		(new Asts.arithmeticExp(Asts.constantExp (Asts.expVal (1)),
    //								    "PLUS",
    //									Asts.constantExp (Asts.expVal (2))))   
    @Override
    public ArithmeticExp asArithmetic() {
        return this;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Given: env representing the current environment of this call
    // Returns: the result of the operation on the lhs and rhs of this object
    // Strategy: Case on operator of this
    // Example: (new Asts.arithmeticExp(Asts.constantExp (Asts.expVal (1)),
    //								    "PLUS",
    //									Asts.constantExp (Asts.expVal (2))))
    //			.value(new HashMap<String, ExpVal>())
    //			=> Asts.expVal(3)  
    @Override
    public ExpVal value(Map<String, ExpVal> env) {
        // multiplication
        if (operator.equals(TIMES)) {
            long result = this.lhs.value(env).asInteger() * this.rhs.value(env).asInteger();
            return Asts.expVal(result);

        } else if (operator.equals(PLUS)) {
            long result = this.lhs.value(env).asInteger() + this.rhs.value(env).asInteger();
            return Asts.expVal(result);

        } else if (operator.equals(MINUS)) {
            long result = this.lhs.value(env).asInteger() - this.rhs.value(env).asInteger();
            return Asts.expVal(result);

            // EQ operator works on both boolean and integer
        } else if (operator.equals(EQ)) {
            ExpVal compLeft = this.lhs.value(env);
            ExpVal compRight = this.rhs.value(env);
            boolean result = false;

            // both lhs and rhs are boolean
            if (compLeft.isBoolean() && compRight.isBoolean()) {
                result = compLeft.asBoolean() == compRight.asBoolean();
            }
            // both lhs and rhs are integer
            else if (compLeft.isInteger() && compRight.isInteger()) {
                result = compLeft.asInteger() == compRight.asInteger();
            }

            return Asts.expVal(result);

        } else if (operator.equals(GT)) {
            boolean result = this.lhs.value(env).asInteger() > this.rhs.value(env).asInteger();
            return Asts.expVal(result);

        } else if (operator.equals(LT)) {
            boolean result = this.lhs.value(env).asInteger() < this.rhs.value(env).asInteger();
            return Asts.expVal(result);
        }

        throw new UnsupportedOperationException();
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the lhs of this ArithmeticExp
    // Example: (new Asts.arithmeticExp(Asts.constantExp (Asts.expVal (1)),
    //								    "PLUS",
    //									Asts.constantExp (Asts.expVal (2))))
    //			.leftOperand()
    //   		=> Asts.constantExp (Asts.expVal (1))
    @Override
    public Exp leftOperand() {
        return this.lhs;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the rhs of this ArithmeticExp
    // Example: (new Asts.arithmeticExp(Asts.constantExp (Asts.expVal (1)),
    //								    "PLUS",
    //									Asts.constantExp (Asts.expVal (2))))
    //			.rightOperand()
    //   		=> Asts.constantExp (Asts.expVal (2))
    @Override
    public Exp rightOperand() {
        return this.rhs;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the operation of this ArithmeticExp
    // Example: (new Asts.arithmeticExp(Asts.constantExp (Asts.expVal (1)),
    //								    "PLUS",
    //									Asts.constantExp (Asts.expVal (2))))
    //			.operation()
    //   		=> "PLUS"
    @Override
    public String operation() {
        return this.operator;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: a string representation of this object
    // Strategy: use simpler functions
    // Example: (new Asts.arithmeticExp(Asts.constantExp (Asts.expVal (1)),
    //								    "PLUS",
    //									Asts.constantExp (Asts.expVal (2))))
    //			.toString()
    //			=>  "ArithmeticExpImpl: {lhs=1, operator='PLUS', rhs=2}"		
    @Override
    public String toString() {
        return "ArithmeticExpImpl: {" +
                "lhs=" + lhs +
                ", operator='" + operator + '\'' +
                ", rhs=" + rhs +
                '}';
    }
    //-----------------------------------------------------------------------------------------------------------
}
