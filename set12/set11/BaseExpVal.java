/**
 * Created by Abhishek Mulay on 4/3/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

// Abstract base class for classes that implement ExpVal.
//
// To define a class that implements ExpVal:
//     make that class a subclass of BaseExpVal

abstract public class BaseExpVal implements ExpVal {

    // Returns true iff this ExpVal is a boolean,
    @Override
    public boolean isBoolean() {
        return false;
    }

    //--------------------------------------------------------------------------
    // Returns true iff this ExpVal is a integer
    @Override
    public boolean isInteger() {
        return false;
    }

    //--------------------------------------------------------------------------
    // Precondition: the corresponding predicate above is true.
    // Returns this.
    @Override
    public boolean isFunction() {
        return false;
    }

    //--------------------------------------------------------------------------
    // Precondition: the corresponding predicate above is true.
    // Returns this.
    @Override
    public boolean asBoolean() {
        throw new UnsupportedOperationException();
    }

    //--------------------------------------------------------------------------
    // Precondition: the corresponding predicate above is true.
    // Returns this.
    @Override
    public long asInteger() {
        throw new UnsupportedOperationException();
    }

    //--------------------------------------------------------------------------
    // Precondition: the corresponding predicate above is true.
    // Returns this.
    @Override
    public FunVal asFunction() {
        throw new UnsupportedOperationException();
    }
    //--------------------------------------------------------------------------
}
