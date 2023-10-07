package org.roug.usim;

import java.util.concurrent.locks.ReentrantLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Straight-through bus with no memory management unit.
 */
public class BusStraight
        extends BusMemoryOnly
        implements Bus8Motorola {

    private static final Logger LOGGER = LoggerFactory.getLogger(BusStraight.class);

    /** Active NMI signals. */
    private int activeNMIs;

    /** Active IRQ requests. */
    private int activeIRQs;

    /** Active FIRQ requests. */
    private int activeFIRQs;

    private ReentrantLock lockObject = new ReentrantLock();

    /** Port memory space. */
    private MemorySegment ports;

    /**
     * Constructor.
     */
    public BusStraight() {
    }

    /**
     * Constructor: Create bus and allocate memory from address 0 and up.
     *
     * @param memorySize - The size of the memory.
     */
    public BusStraight(int memorySize) {
        super(memorySize);
    }

    /**
     * Accept an NMI signal.
     */
    @Override
    public synchronized void signalNMI(boolean state) {
        if (state) {
            activeNMIs++;
            notifyAll();
        } else {
            if (activeNMIs > 0) activeNMIs--;
        }
    }

    @Override
    public synchronized void clearNMI() {
        activeNMIs = 0;
    }

    /**
     * Do we have active NMIs?
     */
    @Override
    public boolean isNMIActive() {
        return activeNMIs > 0;
    }

    /**
     * Accept an FIRQ signal.
     */
    @Override
    public void signalFIRQ(boolean state) {
        synchronized(this) {
            if (state) {
                activeFIRQs++;
                notifyAll();
            } else {
                activeFIRQs--;
            }
        }
    }

    /**
     * Do we have active FIRQs?
     */
    @Override
    public boolean isFIRQActive() {
        return activeFIRQs > 0;
    }

    /**
     * Accept a signal on the IRQ pin. A device can raise the voltage on the IRQ
     * pin, which means the device sends an interrupt request. The CPU must then
     * check the devices and get the device to lower the signal again.
     * In this implementation, the signals from several devices are ORed
     * together to the same pin on the CPU. Since this can't easily be emulated,
     * it is the responsibility of the device that it doesn't raise IRQ twice
     * in a row.
     * If IRQs are ignored when a device signals, then it must be received 
     * when IRQs are accepted again (if the device hasn't lowered it).
     *
     * NOTE: The ORing logic should be move to a memory-bus class, so it can
     * be replaced for different hardware emulations.
     *
     * @param state - true if IRQ is raised from the device, false if IRQ is
     * lowered.
     */
    @Override
    public void signalIRQ(boolean state) {
        synchronized(this) {
            if (state) {
                activeIRQs++;
                notifyAll();
            } else {
               activeIRQs--;
            }
        }
    }

    /**
     * Do we have active IRQs?
     */
    @Override
    public boolean isIRQActive() {
        return activeIRQs > 0;
    }

    /**
     * Reset the bus.
     */
    public void reset() {
    }

}

