import java.util.Map;

/**
 * Created by Abhishek Mulay on 4/3/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

// Constructor template for ExpValInteger:
//    new ExpValInteger(long)
//      OR
//    new ExpValInteger(Long)
//
// Interpretation:
//    This class represents an integer value

public class ExpValInteger extends BaseExpVal implements ExpVal {

    // value of this expression
    private long value;

    // constructor
    public ExpValInteger(long value) {
        this.value = value;
    }
    //-----------------------------------------------------------------

    //Returns: true if this is an Integer, false otherwise
    @Override
    public boolean isInteger() {
        return true;
    }
    //-----------------------------------------------------------------

    // returns integer value of this expression
    @Override
    public long asInteger() {
        return this.value;
    }
    //-----------------------------------------------------------------

    @Override
    public String toString() {
        return "ExpValInteger{" +
                "value=" + value +
                '}';
    }
}
