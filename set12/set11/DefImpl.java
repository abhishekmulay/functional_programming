import java.util.List;
import java.util.Map;

/**
 * Created by Abhishek Mulay on 3/31/17.
 */
public class DefImpl extends BaseExp implements Def {

    private String lhs;
    private Exp rhs;

    public DefImpl(String lhs, Exp rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the left hand side of this definition
    @Override
    public String lhs() {
        return this.lhs;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the right hand side of this definition
    @Override
    public Exp rhs() {
        return this.rhs;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: true because this is a Def
    @Override
    public boolean isDef() {
        return true;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: this as this is a already a Def
    @Override
    public Def asDef() {
        return this;
    }

    //-----------------------------------------------------------------------------------------------------------
    // Given: env representing the current environment of this call
    // Returns runtime exception as def evaluation is handled outside of object
    @Override
    public ExpVal value(Map<String, ExpVal> env) {
        throw new UnsupportedOperationException();
    }

    //-----------------------------------------------------------------------------------------------------------
    // Returns: the representation of this object as a string
    @Override
    public String toString() {
        return "DefImpl: {" +
                "lhs='" + lhs + '\'' +
                ", rhs=" + rhs +
                '}';
    }
    //-----------------------------------------------------------------------------------------------------------
}
