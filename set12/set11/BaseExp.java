import java.util.List;
import java.util.Map;

/**
 * Created by Abhishek Mulay on 4/2/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

// Abstract base class for classes that implement Exp.
//
// To define a class that implements Exp:
//     make that class a subclass of BaseExp
//     within that class, define the following abstract method:
//     public abstract ExpVal value(Map<String, ExpVal> env)
abstract public class BaseExp implements Exp {

    // abstract method, any class that inherits from BaseExp must implement this method.
    public abstract ExpVal value(Map<String, ExpVal> env);

    //----------------------------------------------------------------------------------------
    // Returns false unless overridden by the implementing class
    @Override
    public boolean isConstant() {
        return false;
    }

    //----------------------------------------------------------------------------------------
    // Returns false unless overridden by the implementing class
    @Override
    public boolean isIdentifier() {
        return false;
    }

    //----------------------------------------------------------------------------------------
    // Returns false unless overridden by the implementing class
    @Override
    public boolean isLambda() {
        return false;
    }

    //----------------------------------------------------------------------------------------
    // Returns false unless overridden by the implementing class
    @Override
    public boolean isArithmetic() {
        return false;
    }

    //----------------------------------------------------------------------------------------
    // Returns false unless overridden by the implementing class
    @Override
    public boolean isCall() {
        return false;
    }

    //----------------------------------------------------------------------------------------
    // Returns false unless overridden by the implementing class
    @Override
    public boolean isIf() {
        return false;
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public ConstantExp asConstant() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public IdentifierExp asIdentifier() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public LambdaExp asLambda() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public ArithmeticExp asArithmetic() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public CallExp asCall() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public IfExp asIf() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public boolean isPgm() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public boolean isDef() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns true, as this abstract class implements exp
    @Override
    public boolean isExp() {
        return true;
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public List<Def> asPgm() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns runtime exception unless overridden by the implementing class
    @Override
    public Def asDef() {
        throw new UnsupportedOperationException();
    }

    //----------------------------------------------------------------------------------------
    // Returns this, because this class implements exp 
    @Override
    public Exp asExp() {
        return this;
    }
    //----------------------------------------------------------------------------------------
}
