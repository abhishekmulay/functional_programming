import java.util.*;

/**
 * Created by Abhishek Mulay on 3/30/17.
 */

//////////////////////////////////////////////////////////////////////////
//                             DATA DEFINITION                         //
////////////////////////////////////////////////////////////////////////

//Constructor template for Programs:
//    new Programs()

//Interpretation:
//    This class is the entry point to start program execution.

public class Programs {

    // Given: pgm representing a number of definitions in a program, the first
    //        being the entryPoint, and inputs representing Expressions to be
    //        passed into the first definition's right hand side
    // Where: The first definition in defs list is a LambdaExp.
    // Returns: the final ExpressionVal of the program evaluated in terms of the definitions
    public static ExpVal run(List<Def> pgm, List<ExpVal> inputs) {
        Map<String, ExpVal> env = new HashMap<>();

        Exp entryPoint = pgm.get(0).rhs();
        if (entryPoint.isLambda()) {
            // number of inputs passed to run should be equal to arguments required by entry point lambda expression
            if (entryPoint.asLambda().formals().size() == inputs.size()) {
                return handleLambda(pgm, entryPoint, env, inputs);
            }
        }

        // if it gets here then entryPoint is not a valid input to run.
        throw new RuntimeException("Invalid parameters passed to run. pgm:" + pgm + " inputs:" + inputs);
    }
    //-----------------------------------------------------------------------------------------------------------

    // Given: pgm representing a number of definitions in a program, first
    //        entryPoint definition which is a LambdaExp, runtime environment env, and inputs representing expressions
    //        to be passed into the first definition's right hand side.
    // Returns: the final ExpressionVal of the program evaluated in terms of the definitions
    public static ExpVal handleLambda(List<Def> pgm, Exp entryPoint, Map<String, ExpVal> env, List<ExpVal> inputs) {

        for (int index = 0; index < pgm.size(); index++) {
            String lhs = pgm.get(index).lhs();
            Exp rhs = pgm.get(index).rhs();

            if (pgm.get(index).rhs().isLambda()) {
                FunVal funVal = Asts.expVal(rhs.asLambda(), env);
                env.put(lhs, funVal);

            } else {
                env.put(lhs, rhs.value(env));
            }
        }

        // create new runtime environment.
        Map<String, ExpVal> newEnv = new HashMap<>();
        newEnv.putAll(env);
        List<String> formals = entryPoint.asLambda().formals();
        for (int index = 0; index < formals.size(); index++) {
            newEnv.put(formals.get(index), inputs.get(index));
        }

        return entryPoint.asLambda().body().value(newEnv);
    }
    //-----------------------------------------------------------------------------------------------------------

    //////////////////////////////////////////////////////////////////////////
    //                             Set11  Question 2                       //
    ////////////////////////////////////////////////////////////////////////

    // Given: a filename of a ps11 program 
    // Returns: the set of all variable names that occur free within
    // the program.
    //
    // Examples:
    //     Programs.undefined ("church.ps11")    // returns an empty set
    //     Programs.undefined ("bad.ps11")       // returns { "x", "z" }
    //
    //   where bad.ps11 is a file containing:
    //
    //     f (x, y) g (x, y) (y, z);
    //     g (z, y) if 3 > 4 then x else f
    //
    public static Set<String> undefined(String filename) {
        String pgm = Scanner.readPgm(filename);
        List<Def> defs = Scanner.parsePgm(pgm);
        HashSet<String> variables = new HashSet<>();
        HashSet<String> undefinedVariables = new HashSet<>();

        //build global variable definitions
        for (Def definition : defs) {
            variables.add(definition.lhs());
        }

        //evaluate individual definition variables
        for (Def definition : defs) {
            Exp rhs = definition.rhs();
            if (rhs.isLambda() || rhs.isConstant()) {
                undefinedVariables.addAll(getUndefinedInExp(rhs, variables));
            } else {
                throw new IllegalArgumentException("Illegal expression as rhs of definition. Expected a LambdaExp or " +
                        "ConstantExp.");
            }
        }

        return undefinedVariables;
    }
    //-----------------------------------------------------------------------------------------------------------

    // Given: An Exp and a set of variable names
    // Returns: a set of free variables inside this expression.
    // Example:
    //    ExpValInteger expValInteger = new ExpValInteger(2);
    //    ConstantExpImpl exp = new ConstantExpImpl(expValInteger);
    //    HashSet<String> variables = new HashSet<>();
    //    getUndefinedInExp(exp, variables) => []
    //
    // Halting measure: length of (defs + number of expressions inside each individual def)
    private static Set<String> getUndefinedInExp(Exp exp, Set<String> variables) {
        Set<String> undefinedVariables = new HashSet<>();
        //definedVariables are copied as we are in a new scope and need to be immutable
        Set<String> definedVariables = new HashSet<>(variables);
        Set<String> encounteredVariables = new HashSet<>();

        if (exp.isLambda()) {
            List<String> formals = exp.asLambda().formals();
            //lambda only adds to env
            definedVariables.addAll(formals);
            //recurse on the body of the lambda
            undefinedVariables.addAll(getUndefinedInExp(exp.asLambda().body(), definedVariables));

        } else if (exp.isIdentifier()) {
            //identifier represents an encountered variable
            encounteredVariables.add(exp.asIdentifier().name());

        } else if (exp.isConstant()) {
            //env has no effect on Constants

        } else if (exp.isCall()) {
            //recurse on the operator
            undefinedVariables.addAll(getUndefinedInExp(exp.asCall().operator(), definedVariables));

            //recurse on each argument
            for (Exp argument : exp.asCall().arguments()) {
                undefinedVariables.addAll(getUndefinedInExp(argument, definedVariables));
            }

        } else if (exp.isArithmetic()) {
            //recurse on left and right side of exp
            undefinedVariables.addAll(getUndefinedInExp(exp.asArithmetic().leftOperand(), definedVariables));
            undefinedVariables.addAll(getUndefinedInExp(exp.asArithmetic().rightOperand(), definedVariables));

        } else if (exp.isIf()) {
            //recurse on test, then, and else of exp
            undefinedVariables.addAll(getUndefinedInExp(exp.asIf().testPart(), definedVariables));
            undefinedVariables.addAll(getUndefinedInExp(exp.asIf().thenPart(), definedVariables));
            undefinedVariables.addAll(getUndefinedInExp(exp.asIf().elsePart(), definedVariables));
        }

        // remove all elements that are valid
        encounteredVariables.removeAll(definedVariables);

        undefinedVariables.addAll(encounteredVariables);
        return undefinedVariables;
    }
    //-----------------------------------------------------------------------------------------------------------

    //////////////////////////////////////////////////////////////////////////
    //                             Set11  Question 1                       //
    ////////////////////////////////////////////////////////////////////////

    // Runs the ps11 program found in the file named on the command line
    // on the integer inputs that follow its name on the command line,
    // printing the result computed by the program.
    //
    // Example:
    //
    //     % java Programs sieve.ps11 2 100
    //     25
    public static void main(String[] args) {
        if (args.length >= 2) {
            String filename = args[0];
            Object val = evaluateProgram(filename, args);
            System.out.println(val);
        } else {
            throw new IllegalArgumentException("No or invalid arguments passed. " +
                    "\nUsage: java Programs <filename> <input> ...");
        }
    }
    //-----------------------------------------------------------------------------------------------------------

    // Runs the ps11 program found in the given filename
    // on the integer inputs that follow its name in the args array.
    // Example:
    //         String filename = "sieve.ps11";
    //         String args[] = new String[]{filename, "2", "100"};
    //         Programs.evaluateProgram(filename, args) => 25
    //
    public static Object evaluateProgram(String filename, String[] args) {
        // read the file into a string
        String pgm = Scanner.readPgm(filename);
        List<ExpVal> inputs = new ArrayList<ExpVal>();
        for (int i = 1; i < args.length; i = i + 1) {
            long input = Long.parseLong(args[i]);
            inputs.add(Asts.expVal(input));
        }
        // Use parser to evaluate this program
        ExpVal result = Scanner.runPgm(pgm, inputs);

        Object val = null;
        if (result.isBoolean()) {
            val = result.asBoolean();

        } else if (result.isInteger()) {
            val = result.asInteger();

        } else if (result.isFunction()) {
            val = result.asFunction();
        }
        return val;
    }
    //-----------------------------------------------------------------------------------------------------------

}

