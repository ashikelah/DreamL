import javax.swing.*;

/**
 * DReaM IDE main class in this class we start our main application which is our main program
 * @author Michael M:
 */
public class DreamIDE {
    /**
     * main starter code
     * @param args to take command line argument
     */
    public static void main (String[] args) {
        SwingUtilities.invokeLater(() -> showIde());
    }

    private static void showIde () {
        EditorWindow window = new EditorWindow();
        window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        window.pack();
        window.setLocationRelativeTo(null);
        window.setVisible(true);
    }
}
