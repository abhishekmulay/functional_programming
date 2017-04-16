import java.util.ArrayList;
import java.util.List;

/**
 * Created by Abhishek Mulay on 4/3/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

// Constructor template for ExpValBoolean:
//    new ExpValBoolean(boolean)
//      OR
//    new ExpValBoolean(Boolean)
//
// Interpretation:
//    This class represents a boolean value

public class ExpValBoolean extends BaseExpVal implements ExpVal {

    // value of this expression
    private boolean value;

    // constructor
    public ExpValBoolean(boolean value) {
        this.value = value;
    }
    //------------------------------------------------------------------

    //Returns: true if this is a boolean, false otherwise
    @Override
    public boolean isBoolean() {
        return true;
    }
    //------------------------------------------------------------------

    //Returns: boolean value of this expression
    @Override
    public boolean asBoolean() {
        return this.value;
    }
    //------------------------------------------------------------------

    public FunVal asFunction() {
        return null;
    }
}
