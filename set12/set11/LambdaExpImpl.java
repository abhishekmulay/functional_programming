import java.util.List;
import java.util.Map;

/**
 * Created by Abhishek Mulay on 3/31/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

// Constructor template for LambdaExpImpl:
//    new LambdaExpImpl(List<String>, Exp)
//
// Interpretation:
//    This class represents a lambda expression which has a list of parameter names
//    and a body expression.

public class LambdaExpImpl extends BaseExp implements LambdaExp {

    // list of parameter names that are passed to this lambda expression
    private List<String> formals;
    // body of this lambda expression
    private Exp body;

    // constructor
    public LambdaExpImpl(List<String> formals, Exp body) {
        this.formals = formals;
        this.body = body;
    }

    //----------------------------------------------------------------------------------
    // Returns: the formals(arguments) of this Lambda
    @Override
    public List<String> formals() {
        return this.formals;
    }

    //----------------------------------------------------------------------------------
    // Returns: the body(code) of this Lambda
    @Override
    public Exp body() {
        return this.body;
    }

    //----------------------------------------------------------------------------------
    // Returns: true because this is a Lambda
    @Override
    public boolean isLambda() {
        return true;
    }

    //----------------------------------------------------------------------------------
    // Returns: this because this is already a Lambda
    @Override
    public LambdaExp asLambda() {
        return this;
    }

    //----------------------------------------------------------------------------------
    // Given: env representing the current environment of this call
    // Returns: the result of this call as an ExpVal within the provided environment
    @Override
    public ExpVal value(Map<String, ExpVal> env) {
        return Asts.expVal(this, env);
    }

    //----------------------------------------------------------------------------------
    // return value of this lambda expression.
    @Override
    public String toString() {
        return "LambdaExpImpl{ formals=" + formals + ", body=" + body + '}';
    }
    //----------------------------------------------------------------------------------
}
