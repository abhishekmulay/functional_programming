import java.util.List;
import java.util.Map;

/**
 * Created by Abhishek Mulay on 3/30/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

//Constructor templates for ConstantExpImpl:
//      new ConstantExpImpl(ExpVal)
//
//Interpretation:
//    This class represents an expression which has a constant value,
//    i.e. the value of this class does not change.

public class ConstantExpImpl extends BaseExp implements ConstantExp {

    private ExpVal value;

    ConstantExpImpl(ExpVal val) {
        this.value = val;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the value of this constant
    @Override
    public ExpVal value() {
        return this.value;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: true because this is a ConstantExp
    @Override
    public boolean isConstant() {
        return true;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: this because this is a ConstantExp
    @Override
    public ConstantExp asConstant() {
        return this;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Given: env representing the current environment of this call
    // Returns: the result of this call (environment does not 
    // effect value of a constant)
    @Override
    public ExpVal value(Map<String, ExpVal> env) {
        return this.value;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the representation of this object as a string
    @Override
    public String toString() {
        return "ConstantExpImpl: {value=" + value + '}';
    }

    //-----------------------------------------------------------------------------------------------------------

}
