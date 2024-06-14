import javax.swing.*;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.text.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.*;
import java.time.Duration;
import java.time.Instant;
import java.util.concurrent.ExecutionException;

/**
 * DReaM IDE main class in this class we have our editor GUI for edditing and viewing files
 * @author Michael M., shantanu G. Ojha
 */
public class EditorWindow extends JFrame {
    private static final String TITLE = "DReaM Development Environment";

    /**
     * constructor to set tital on initiation
     */
    public EditorWindow() {
        setTitle(TITLE);
        buildGui();
    }

    /**
     * start the GUI
     */
    private void buildGui() {
        Dimension size = new Dimension(650, 430);
        setMinimumSize(size);
        setLayout(new BorderLayout());

        // creates the code editing area
        CodeEditor codeEditor = new CodeEditor();
        JScrollPane scrollPane = new JScrollPane(codeEditor);
        TextLineNumber textLineNumber = new TextLineNumber(codeEditor);
        scrollPane.setRowHeaderView(textLineNumber);
        addWindowListener(new WindowAdapter() {
            public void windowOpened(WindowEvent e) {
                codeEditor.requestFocus();
            }
        });

        // create the output panel
        OutputPanel outputPanel = new OutputPanel();

        // create the toolbar
        ToolBarWidget toolbar = new ToolBarWidget(codeEditor, outputPanel);
        toolbar.setFloatable(false);
        toolbar.setRollover(true);

        JSplitPane splitPane = new JSplitPane(JSplitPane.VERTICAL_SPLIT, scrollPane, new JScrollPane(outputPanel));
        splitPane.setDividerLocation((int) size.getHeight() - (int) size.getHeight() / 3);

        setPreferredSize(size);
        add(toolbar, BorderLayout.PAGE_START);
        add(splitPane, BorderLayout.CENTER);
    }

    /**
     *  Builds the main coding editor panel.
     */
    private class CodeEditor extends JTextArea {

        public CodeEditor() {
            setColumns(100);
            setRows(1000);
            setTabSize(5);
            setFont(new Font("Liberation Mono", Font.PLAIN, 15));
            setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        }
    }

    /**
     *  Builds the output panel.
     */
    private class OutputPanel extends JTextArea {

        public OutputPanel() {
            setEditable(false);
            setForeground(Color.BLACK);
            setBackground(new Color(238, 238, 238)); // swing component default color
            setFont(new Font("Liberation Mono", Font.PLAIN, 12));
            setBorder(BorderFactory.createEmptyBorder(7, 7, 7, 7));
        }
    }

    /**
     * The toolbar widget.
     */
    private class ToolBarWidget extends JToolBar {
        private final JTextComponent codeEditor;
        private final JTextComponent output;
        private final PrologExecutor executor;
        /**
         * setting up toolbarWidget
         */
        public ToolBarWidget(CodeEditor codeEditor, OutputPanel output) {
            this.codeEditor = codeEditor;
            this.output = output;
            this.executor = new PrologExecutor();
            addbuttons();
        }

        /**
         * add button functionality
         */
        private void addbuttons() {
            JFileChooser fileChooser = new JFileChooser();
            fileChooser.setCurrentDirectory(new File(System.getProperty("user.dir") + "/SER502-Spring2022-Team20/src/test"));
            fileChooser.setFileFilter(new FileNameExtensionFilter("Dream program files", "dm"));

            JButton newDoc = new JButton("New");
            newDoc.addActionListener(l -> {
                codeEditor.setText("");
                EditorWindow.this.setTitle(TITLE);
                fileChooser.setSelectedFile(null);
            });
            add(newDoc);

            addSeparator();
            JButton open = new JButton("Open...");
            open.addActionListener(l -> openFile(fileChooser));
            add(open);

            addSeparator();
            JButton save = new JButton("Save...");
            save.addActionListener(l -> saveFile(fileChooser));
            add(save);

            addSeparator();
            JButton saveAs= new JButton("Save as");
            saveAs.addActionListener(l -> saveAsFile(fileChooser));
            add(saveAs);

            addSeparator();
            JButton compile = new JButton("Compile");
            compile.setToolTipText("Compiles DReaM code");
            compile.addActionListener(l -> compileCode());
            add(compile);

            addSeparator();
            JButton run = new JButton("Run");
            run.setToolTipText("Execute the code");
            run.addActionListener(l -> runCode());
            add(run);

            addSeparator();
            JButton about = new JButton("About");
            about.addActionListener(l -> showAboutDialog());
            add(about);
        }

        /**
         * open the give file in editor
         * @param fileChooser file path
         */
        private void openFile(JFileChooser fileChooser) {
            int returnVal = fileChooser.showOpenDialog(EditorWindow.this);
            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = fileChooser.getSelectedFile();
                EditorWindow.this.setTitle(TITLE + " (" + file.getName() + ")");
                StringBuilder sb = new StringBuilder();
                try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                    String st;
                    while ((st = reader.readLine()) != null)
                        sb.append(st + "\n");
                } catch (IOException e) {
                    output.setText(e.getMessage());
                }
                codeEditor.setText(sb.toString());
                codeEditor.setCaretPosition(0);
            }
        }

        /**
         * save the file with the given files chooser
         * @param fileChooser file chooser
         */
        private void saveFile(JFileChooser fileChooser) {
            int returnVal = JFileChooser.APPROVE_OPTION;
            if (fileChooser.getSelectedFile() == null) // show dialog if no file is selected
                returnVal = fileChooser.showOpenDialog(EditorWindow.this);

            if (returnVal == JFileChooser.APPROVE_OPTION && !codeEditor.getText().isEmpty()) {
                String fileName = fileChooser.getSelectedFile().getAbsolutePath();
                File file = new File(fileName.endsWith(".dm") ? fileName : fileName + ".dm");
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                    writer.write(codeEditor.getText());
                    writer.close();
                } catch (IOException e) {
                    output.setText(e.getMessage());
                }
            }
        }
        private void saveAsFile(JFileChooser fileChooser){
            fileChooser.setDialogTitle("Specify a file to save");
            int   returnVal = fileChooser.showSaveDialog(EditorWindow.this);
            if (returnVal == JFileChooser.APPROVE_OPTION && !codeEditor.getText().isEmpty()) {
                String textContent= codeEditor.getText();
                File fileToSaveAs = fileChooser.getSelectedFile();
                try{
                    FileWriter fw= new FileWriter(fileToSaveAs.getPath());
                    fw.write(textContent);
                    fw.flush();
                    fw.close();
                } catch (IOException e) {
                    output.setText(e.getMessage());
                }

            }
        }

        /**
         * comites the code
         */
        private void compileCode() {
            try {
                String sourceCode = codeEditor.getText();
                if (sourceCode == null || sourceCode.isEmpty()) {
                    output.setText("No code to compile");
                    return;
                }

                Instant startTime = Instant.now();
                executor.compile(sourceCode);
                Instant endTime = Instant.now();
                String parseTree = executor.getParseTree();
                if (parseTree == null || parseTree.isEmpty()) {
                    output.setText("Compilation error \nCheck your code");
                    return;
                }

                String compilationTime = String.valueOf(Duration.between(startTime, endTime).toMillis());
                output.setText("Compilation completed without error \nCompilation time : " + compilationTime + " ms");
            } catch (InterruptedException | ExecutionException | IOException e) {
                output.setText(e.getMessage());
            }
        }

        /**
         * run the code
         */
        private void runCode() {
            try {
                String parseTree = executor.getParseTree();
                if (parseTree == null || parseTree.isEmpty()) {
                    output.setText("No compiled code exists \nPlease compile your code first");
                    return;
                }

                Instant startTime = Instant.now();
                String result = executor.run("");
                Instant endTime = Instant.now();
                String compilationTime = String.valueOf(Duration.between(startTime, endTime).toMillis());
                output.setText(result + "\n-------------------\nProcess finished. \nRunning time : " + compilationTime + " ms");
            } catch (InterruptedException | ExecutionException | IOException e) {
                output.setText(e.getMessage());
            }
        }

        /**
         * Show about Dialog box
         */
        private void showAboutDialog() {
            JOptionPane.showMessageDialog(EditorWindow.this, "Team 20\n Team members\n1. Shantanu G. Ojha");
        }
    }
}