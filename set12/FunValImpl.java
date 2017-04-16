import java.util.Map;

/**
 * Created by Abhishek Mulay on 4/1/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

//Constructor template for FunValImpl:
//    new FunValImpl(LambdaExp, Map<String, ExpVal>)
//
//Interpretation:
//    This class represents an implementation of FunVal, this will call the given
//    lambda expression with given environment as execution context.

public class FunValImpl implements FunVal {

    // given lambda function
    private LambdaExp exp;

    // execution context for given lambda function
    private Map<String, ExpVal> env;

    // Constructor
    public FunValImpl(LambdaExp exp, Map<String, ExpVal> env) {
        this.exp = exp;
        this.env = env;
    }

    //----------------------------------------------------------------------------
    // Returns: false as this represents a function
    @Override
    public boolean isBoolean() {
        return false;
    }

    //----------------------------------------------------------------------------
    // Returns: false as this represents a function
    @Override
    public boolean isInteger() {
        return false;
    }

    //----------------------------------------------------------------------------
    // Returns: true as this represents a function 
    @Override
    public boolean isFunction() {
        return true;
    }

    //----------------------------------------------------------------------------
    // Returns: throws an exception as this does not represent a Boolean
    @Override
    public boolean asBoolean() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------
    // Returns: throws an exception as this does not represent an Integer
    @Override
    public long asInteger() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------
    // Returns: the value of this function in its environment 
    //    cast to a Function if the value is a Function
    @Override
    public FunVal asFunction() {
        return this;
    }

    //----------------------------------------------------------------------------
    // Returns: the LambdaExp of this FunVal
    @Override
    public LambdaExp code() {
        return this.exp;
    }

    //----------------------------------------------------------------------------
    // Returns: the environment of this FunVal
    @Override
    public Map<String, ExpVal> environment() {
        return this.env;
    }
    //----------------------------------------------------------------------------

}
