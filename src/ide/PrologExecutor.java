import java.io.*;
import java.util.concurrent.*;

/**
 * this class is base executor class for running shell command for prolog.
 * @author Michael M.
 */
public class PrologExecutor {
    private static final String PROLOG_CMD = "swipl -s %s \"%s.\"";
    private static final String DREAM_FILE = "DReaM_DCG.pl";

    // the main predicate to do the parsing and evaluations
    private static final String PARSER_PREDICATE = "dream_program(T, [%s], [])";
    private static final String EVAL_PREDICATE = "eval_dream_program(%s, [%s], R)";

    private String parseTree;
    private final boolean isWindows;
    private final ProcessBuilder builder;

    /**
     * constructor for initiating the prolog executor
     */
    public PrologExecutor() {
        this.parseTree = null;
        this.builder = new ProcessBuilder();
        this.isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
    }

    /**
     * Compiles the source code and generates a parse tree.
     * @param sourceCode is DReaM source code.
     */
    public void compile(String sourceCode) throws InterruptedException, ExecutionException, IOException {
        String tokenizedCode = new Tokenizer(sourceCode).getTokenized();
        String predicate = String.format(PARSER_PREDICATE, tokenizedCode);
        String cmd = String.format(PROLOG_CMD, DREAM_FILE, predicate);
        this.parseTree = execute(cmd).replace (System.lineSeparator(), "");
    }

    /**
     * Executes the parse tree
     * @param env are the environment variables
     */
    public String run(String env) throws InterruptedException, ExecutionException, IOException {
        String predicate = String.format(EVAL_PREDICATE, parseTree, env);
        String command = String.format(PROLOG_CMD, DREAM_FILE, predicate);
        String output = execute(command);
        return Tokenizer.unformatStringLiterals(output);
    }

    /**
     * get pare tree
     * @return returns parse tree
     */
    public String getParseTree() {
        return parseTree;
    }

    private String execute(String command) throws ExecutionException, InterruptedException, IOException {
        if (isWindows) {
            builder.command("cmd", "/c", command);
        } else {
            builder.command("sh", "-c", command);
        }
        builder.directory(new File(System.getProperty("user.dir")));
        Process process = builder.start();
        Future<String> task = executeProcess(process);
        return task.get();
    }

    private Future<String> executeProcess(Process process) {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        return executor.submit(() -> {
            return streamReader(process.getInputStream());
        });
    }

    /**
     * read stream and return it in stream form
     * @param in InputStream form commandline
     * @return streamBuilder in string
     * @throws IOException Unable ot read stream
     */
    public String streamReader(InputStream in) throws IOException {
        StringBuilder sb = new StringBuilder();
        InputStreamReader reader = new InputStreamReader(in);
        BufferedReader input = new BufferedReader(reader);
        String line;
        while ((line = input.readLine()) != null) {
            sb.append(line);
            sb.append(System.lineSeparator());
        }
        return sb.toString();
    }

    /**
     * Main program to execue the prolog
     * @param args command line arguments
     */
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("No source file is provided.");
            return;
        }

        try {
            PrologExecutor executor = new PrologExecutor();
            FileInputStream in = new FileInputStream(new File(args[0]));
            String sourceCode = executor.streamReader(in);
            executor.compile(sourceCode);
            if (executor.parseTree == null || executor.parseTree.isEmpty()) {
                System.out.println("Compilation completed with error");
                return;
            }
            System.out.println(executor.run(""));
            System.exit(0);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
