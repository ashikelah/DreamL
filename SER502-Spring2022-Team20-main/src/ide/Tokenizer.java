import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * A tokenizer class for DReaM takes in source code and tokenizes it
 * @author Michael M.
 */
public class Tokenizer {
    private static final String SLICE = " ";
    private static final String COMMENT_SYMBOL = "%";
    private static final List<String> CHARS =
            Arrays.asList("?", ":", ";", ",", "\"", "#", "@", "%", "(", ")", "=", "+", "-", "/", "*", "==", ">", ">=", "<", "<=", "!", "&&", "||", "^", "{", "}", ".");
    private static final List<String> KEY_WORDS =
            Arrays.asList("then", "range", "in", "return", "print", "stop", "number", "if", "string", "else", "boolean", "while", "start", "for", "function");

    private String sourceCode;

    /**
     * constructor for initiating the source code variable
     * @param sourceCode sourcecode in string format
     */
    public Tokenizer(String sourceCode) {
        this.sourceCode = sourceCode;
    }

    /**
     * White space tokenizer.
     */
    public String getTokenized() {
        // add white space for special chars for spliting
        CHARS.forEach(c -> sourceCode = sourceCode.replace(c, SLICE + c + SLICE));

        // slice source code
        List<String> sliced = Arrays.asList(sourceCode.replace("\n", SLICE).split(SLICE)).stream()
                .map(s -> s.toLowerCase().trim())
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());

        // remove comment from sliced code
        boolean isCommentStarted = false;
        List<String> tokens = new ArrayList<>();
        for (String slice : sliced) {
            if (slice.equalsIgnoreCase(COMMENT_SYMBOL)) {
                isCommentStarted = !isCommentStarted;
            } else {
                if (!isCommentStarted)
                    tokens.add(slice);
            }
        }

        // puts single quotes to keywords and string literals
        boolean isStringLiteralStarted = false;
        String literalValue = "";
        List<String> tokenized = new ArrayList<>();
        for (String token : tokens) {
            if (token.equalsIgnoreCase("\"")) {
                isStringLiteralStarted = !isStringLiteralStarted;
                String literal = isStringLiteralStarted ? "{" : "}";
                if (isStringLiteralStarted)
                    literalValue = ""; // reset literal value when a new quote begins
                else
                    tokenized.add("'" + formatStringLiterals(literalValue) + "'");
                tokenized.add(literal);
            } else if (KEY_WORDS.contains(token) || CHARS.contains(token) || isStringLiteralStarted) {
                if (isStringLiteralStarted) // we don't want to tokenize string literals
                    literalValue += token + SLICE;
                else
                    tokenized.add(token);
            } else {
                    tokenized.add(token);
            }
        }

        /**
         *   add single quote to special characters
         */
        return tokenized.stream()
                .map(s -> CHARS.contains(s) ? "'" + s + "'" : s)
                .collect(Collectors.joining(", "));
    }

    /**
     * to replace space with _
     * @param str string input
     * @return formated string
     */
    public static String formatStringLiterals (String str) {
        return str.replace(SLICE, "_");
    }

    /**
     * change "_"to " "
     * @param str input string
     * @return output string
     */
    public static String unformatStringLiterals (String str) {
        return str.replace("_", SLICE);
    }
 }
