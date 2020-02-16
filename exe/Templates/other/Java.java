import java.awt.*;

public class DialogWindow extends Frame {
    private boolean inAnApplet = true;
    private SimpleDialog dialog;
    private TextArea textArea;

    public DialogWindow() {
        textArea = new TextArea(5, 40);
        textArea.setEditable(false);
        add("Center", textArea);
        Button button = new Button("Click to bring up dialog");
        Panel panel = new Panel();
        panel.add(button);
        add("South", panel);
    }

    public boolean handleEvent(Event event) {
        if (event.id == Event.WINDOW_DESTROY) {
            if (inAnApplet) {
                dispose();
            } else {
                System.exit(0);
            }
        }   
        return super.handleEvent(event);
    }

    public boolean action(Event event, Object arg) {
        if (dialog == null) {
            dialog = new SimpleDialog(this, "A Simple Dialog");
        }
        dialog.show();
        return true;
    }

    public void setText(String text) {
        textArea.appendText(text + "\n");
    }

    public static void main(String args[]) {
        DialogWindow window = new DialogWindow();
        window.inAnApplet = false;

        window.setTitle("DialogWindow Application");
        window.pack();
        window.show();
    }
}

class SimpleDialog extends Dialog {
    TextField field;
    DialogWindow parent;
    Button setButton;

    SimpleDialog(Frame dw, String title) {
        super(dw, title, false);
        parent = (DialogWindow)dw;

        //Create middle section.
        Panel p1 = new Panel();
        Label label = new Label("Enter random text here:");
        p1.add(label);
        field = new TextField(40);
        p1.add(field);
        add("Center", p1);

        //Create bottom row.
        Panel p2 = new Panel();
        p2.setLayout(new FlowLayout(FlowLayout.RIGHT));
        Button b = new Button("Cancel");
        setButton = new Button("Set");
        p2.add(b);
        p2.add(setButton);
        add("South", p2);

        //Initialize this dialog to its preferred size.
        pack();
    }

    public boolean action(Event event, Object arg) {
        if ( (event.target == setButton)
           | (event.target == field)) {
            parent.setText(field.getText());
        }
        field.selectAll();
        hide();
        return true;
    }
}