import java.util.List;
import java.util.Map;

/**
 * Created by Abhishek Mulay on 3/31/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

// Constructor template for IfExpImpl:
//      new IfExpImpl(Exp, Exp, Exp)
//
// Interpretation:
//      This class represents a conditional expression.
//      testPart: expression that represents a condition, it should return a boolean value
//      thenPart: expression that will be evaluated if the condition part evaluates
//                to true
//      elsePart: expression that will be evaluated if the conditional part evaluates
//                to false
public class IfExpImpl extends BaseExp implements IfExp {

    // condition
    private Exp testPart;
    // this will be evaluated when condition is true
    private Exp thenPart;
    // this will be evaluated when condition is false
    private Exp elsePart;

    // constructor
    public IfExpImpl(Exp testPart, Exp thenPart, Exp elsePart) {
        this.testPart = testPart;
        this.thenPart = thenPart;
        this.elsePart = elsePart;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the condition(test) part of this IfExp
    @Override
    public Exp testPart() {
        return this.testPart;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the then part of this IfExp
    @Override
    public Exp thenPart() {
        return this.thenPart;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the else part of this IfExp
    @Override
    public Exp elsePart() {
        return this.elsePart;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: true because this is an IfExp
    @Override
    public boolean isIf() {
        return true;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: this as this is already an IfExp
    @Override
    public IfExp asIf() {
        return this;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Given: env representing the current environment of this call
    // Returns: the result of this call as an ExpVal within the provided environment
    // Given: env representing the current environment of this call
    @Override
    public ExpVal value(Map<String, ExpVal> env) {
        if (testPart.value(env).asBoolean()) {
            return thenPart.value(env);
        } else {
            return elsePart.value(env);
        }
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the representation of this object as a string
    @Override
    public String toString() {
        return "IfExpImpl{" +
                "testPart=" + testPart +
                ", thenPart=" + thenPart +
                ", elsePart=" + elsePart +
                '}';
    }
    //-----------------------------------------------------------------------------------------------------------
}
