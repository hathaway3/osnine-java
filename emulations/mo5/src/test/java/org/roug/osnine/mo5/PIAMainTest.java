package org.roug.osnine.mo5;

import org.roug.usim.Bus8Motorola;
import org.roug.usim.BusStraight;
import org.roug.usim.PIA6821;
import org.roug.usim.BitReceiver;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

class ScreenMock extends Screen {

    public ScreenMock(Bus8Motorola bus) {
        super(bus);
    }

    public void setPixelBankActive(boolean state) {}

    public boolean hasKeyPress(int m) { return false; }
}

class PIAMock extends PIAMain {

    public PIAMock(Bus8Motorola bus, Screen screen, TapeRecorder tape, Beeper beeper) {
        super(bus, screen, tape, beeper);
    }

    protected int load(int addr) {
        return super.load(addr);
    }

    protected void store(int addr, int operation) {
        super.store(addr, operation);
    }
    
}

public class PIAMainTest {

    class TapeMock implements BitReceiver {

        public void send(boolean state) {}
    }

    private static final int PIAADDR = 0xA7C0;

    private static final int DDRA = PIAADDR + 0;
    private static final int ORA = PIAADDR + 0;

    private static final int DDRB = PIAADDR + 1;
    private static final int ORB = PIAADDR + 1;

    private static final int CRA = PIAADDR + 2;
    private static final int CRB = PIAADDR + 3;

    /**
     * Set PA5 register to output and then try to write to it.
     */
    @Test
    public void inputToPA5() {
        Bus8Motorola bus = new BusStraight();
        ScreenMock screen = new ScreenMock(bus);
        TapeMock tape = new TapeMock();
        TapeRecorder cassette = new TapeRecorder(bus);
        cassette.setReceiver(tape);
        Beeper beeper = new Beeper(bus);

        PIAMock pia = new PIAMock(bus, screen, cassette, beeper);
        pia.store(CRA, 0);     // Select DDRA
        pia.store(DDRA, 0xF0); // Make top 4 bits output, the others input
        pia.store(CRA, 0x04);  // Select output register
        pia.store(ORA, 0xD0);
        pia.setInputLine(PIA6821.A, 5, false); // This should be ignored
        assertEquals(0xD0, pia.load(ORA));

        pia.setInputLine(PIA6821.A, 2, true);
        assertEquals(0xD4, pia.load(ORA));
    }
}
