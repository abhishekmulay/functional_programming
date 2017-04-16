import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Abhishek Mulay on 3/31/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

//Constructor template for CallExpImpl:
//    new CallExpImpl(Exp, List<Exp>)
//
//Interpretation:
//    This class represents a call expression that applies the given operator
//    on given list of parameters

public class CallExpImpl extends BaseExp implements CallExp {

    private Exp operator;
    private List<Exp> arguments;

    public CallExpImpl(Exp operator, List<Exp> arguments) {
        this.operator = operator;
        this.arguments = arguments;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the Expression operator of this Call
    @Override
    public Exp operator() {
        return this.operator;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the list of Expressions representing the arguments of this call
    @Override
    public List<Exp> arguments() {
        return this.arguments;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: true because this is a CallExp
    @Override
    public boolean isCall() {
        return true;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: this as this is a already a CallExp
    @Override
    public CallExp asCall() {
        return this;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Given: env representing the current environment of this call
    // Returns: the result of this call as an ExpVal within the provided environment
    // Strategy: use simpler functions
    @Override
    public ExpVal value(Map<String, ExpVal> env) {
        ExpVal value = this.operator.value(env);

        // call should be called only for a Function
        if (value.isFunction()) {
            FunVal funVal = value.asFunction();
            List<String> formals = funVal.code().formals();

            // Number of arguments required by function and actual number of arguments does not match.
            if(formals.size() != this.arguments.size()) {
                throw new RuntimeException("Number of formals does not match with number of arguments.");
            }

            // create new runtime environment
            Map<String, ExpVal> envCopy = new HashMap<>();
            envCopy.putAll(funVal.environment());

            // add all arguments to environment
            for (int index=0; index < formals.size(); index++ ) {
                envCopy.put(formals.get(index), this.arguments.get(index).value(env));
            }

            // evaluate the function
            return funVal.code().body().value(envCopy);
        }

        throw new RuntimeException("Invalid FunVal.");
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the representation of this object as a string
    @Override
    public String toString() {
        return "CallExpImpl: {operator=" + operator + ", arguments=" + arguments + '}';
    }

    //-----------------------------------------------------------------------------------------------------------
}
