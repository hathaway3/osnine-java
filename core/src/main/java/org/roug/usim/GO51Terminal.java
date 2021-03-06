package org.roug.usim;

import java.io.OutputStream;
import java.io.IOException;

/**
 * Convert GO51 escape sequences to VT100. This terminal is monochrome.
 */
enum GO51Terminal {

    NORMAL {
        @Override
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                                    throws IOException {
            switch (val) {
                case 0x0B: // Cursor home
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('H');
                    return NORMAL;
                case 0x0C:   // Clear screen and cursor home
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('H');
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('2');
                    clientOut.write('J');
                    return NORMAL;
                case 0x1B:
                    return ESCAPE;
                default:
                    clientOut.write(val);
                    return NORMAL;
            }
        }
    },

    ESCAPE {
        @Override
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                                    throws IOException {
            switch (val) {
                case 0x32:   // Text color
                     return TEXT_COLOR;
                case 0x33:   // Background color
                     return BG_COLOR;
                case 0x41:   // Cursor XY
                    return X_VAL;
                case 0x42:   // Clear to end of line.
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('K');
                    return NORMAL;
                case 0x43:  // Cursor right
                    moveCursor('C', clientOut);
                    return NORMAL;
                case 0x44:  // Cursor up
                    moveCursor('A', clientOut);
                    return NORMAL;
                case 0x45:  // Cursor down
                    moveCursor('B', clientOut);
                    return NORMAL;
                case 0x46:  // Reverse on
                    reversedState = true;
                    setAttribute(7, clientOut);
                    return NORMAL;
                case 0x47:  // Reverse off
                    reversedState = false;
                    setAttribute(0, clientOut);  // Turns all attributes off.
                    if (underlinedState) setAttribute(4, clientOut); // Turn underline on
                    return NORMAL;
                case 0x48:  // Underline on
                    setAttribute(4, clientOut);
                    return NORMAL;
                case 0x49:  // Reverse off
                    underlinedState = false;
                    setAttribute(0, clientOut);  // Turns all attributes off.
                    if (reversedState) setAttribute(7, clientOut); // Turn reversed on
                    return NORMAL;
                case 0x4A:  // Clear to End of screen
                    clientOut.write(ESC);
                    clientOut.write('[');
                    clientOut.write('J');
                    return NORMAL;
                default:
                    clientOut.write(val);
                    return NORMAL;
            }
        }
    },

    X_VAL {
        @Override
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                                    throws IOException {
            column = val + 1; // VT100 starts at 1.
            return Y_VAL;
        }
    },

    Y_VAL {
        @Override
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                                    throws IOException {
            clientOut.write(ESC);
            clientOut.write('[');
            val++; // VT100 starts at 1.
            writeNumber(val, clientOut);
            clientOut.write(';');
            writeNumber(column, clientOut);
            clientOut.write('H');
            return NORMAL;
        }
    },

    TEXT_COLOR {
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                                    throws IOException {
            int colors[] = {37, 34, 30, 32, 31, 33, 35, 36};
            clientOut.write(ESC);
            clientOut.write('[');
            writeNumber(colors[val % 8], clientOut);
            clientOut.write('m');
            return NORMAL;
        }
    },

    BG_COLOR {
        GO51Terminal handleCharacter(int val, OutputStream clientOut)
                                    throws IOException {
            int colors[] = {47, 44, 40, 42, 41, 43, 45, 46};
            clientOut.write(ESC);
            clientOut.write('[');
            writeNumber(colors[val % 8], clientOut);
            clientOut.write('m');
            return NORMAL;
        }
    };


    private static void writeNumber(int val, OutputStream clientOut)
                                    throws IOException {
        if (val >= 100) {
            clientOut.write('0' + val / 100);
            val = val % 100;
        }
        if (val >= 10) {
            clientOut.write('0' + val / 10);
            val = val % 10;
        }
        clientOut.write('0' + val);
    }

    private static void setAttribute(int code, OutputStream clientOut)
                                    throws IOException {
        clientOut.write(ESC);
        clientOut.write('[');
        clientOut.write('0' + code);
        clientOut.write('m');
    }

    private static void moveCursor(char dir, OutputStream clientOut)
                                    throws IOException {
        clientOut.write(ESC);
        clientOut.write('[');
        clientOut.write('1');
        clientOut.write(dir);
    }

    /** Temporary variable to hold column value. */
    private static int column;
    /** State of reversed. */
    private static boolean reversedState;
    /** State of underline. */
    private static boolean underlinedState;

    private static final int ESC = 0x1B;

    abstract GO51Terminal handleCharacter(int val, OutputStream clientOut)
            throws IOException;
}
