package org.roug.osnine;

/**
 * Generic processor run state routines.
 */
public abstract class USim {

    public boolean  halted;  //!< Flag: is the CPU halted?
    /** Memory space. */
    private int[] memory;

// Generic internal registers that we assume all CPUs have

    public UByte        ir; //!< Instruction Register.
    public int        pc; //!< Program Counter.

    /**
     * Constructor.
     */
    public USim() {
    }

    /**
     * Constructor.
     */
    public USim(int memorySize) {
        this();
        allocate_memory(memorySize);
    }

    public void allocate_memory(int size) {
        //TODO: Don't allow allocation of more than 65536 bytes
        memory = new int[size];
    }

    /**
     * Read 16-bit word.
     */
    public abstract int read_word(Word offset);

    /**
     * Read 16-bit word.
     */
    public abstract int read_word(int offset);

    /**
     * Write 16-bit word.
     */
    public abstract void write_word(int offset, Word val);

    /**
     * Write 16-bit word.
     */
    public abstract void write_word(Word offset, Word val);

    /**
     * Reset the simulator.
     */
    public abstract void reset();

    /**
     * Output a status somehow.
     */
    public abstract void status();

    /**
     * Execute one instruction.
     */
    public abstract void execute();

    /**
     * Run until illegal instrution is encountered and then show status.
     */
    public void run() {
        halted = false;
        while (!halted) {
            execute();
        }
        status();
    }

    /**
     * Execute one instruction and then show status.
     */
    public void step() {
        execute();
        status();
    }

    /*
     * Set the halt flag.
     */
    public void halt() {
        halted = true;
    }

    /**
     * Fetch one memory byte from program counter and increment program counter.
     */
    public UByte fetch() {
        int val = read(pc);
        pc += 1;
        //pc.set(pc.get() + 1);

        return UByte.valueOf(val);
    }

    /**
     * Fetch two memory bytes from program counter.
     */
    public Word fetch_word() {
        int val = read_word(pc);
        pc += 2;
        //pc.set(pc.get() + 2);

        return Word.valueOf(val);
    }

    /**
     * Invalid operation encountered. Halt the processor.
     */
    void invalid(final String msg) {
        System.err.format("\ninvalid %s : pc = [%04x], ir = [%04x]\r\n",
                msg == null ? msg : "",
                pc, ir);
        halt();
    }

    //----------------------------------------------------------------------------
    // Primitive (byte) memory access routines
    //----------------------------------------------------------------------------

    /**
     * Single byte read from memory.
     */
    public int read(int offset) {
        return memory[offset];
    }

    /**
     * Single byte read from memory.
     */
    public int read(Word offset) {
        return memory[offset.get()];
    }

    /**
     * Single byte read from memory.
     */
    /*
    public UByte read(int offset) {
        return memory[offset];
    }
    */

    /**
     * Single byte write to memory.
     */
    public void write(int offset, UByte val) {
        memory[offset] = val.intValue();
    }

    /**
     * Single byte write to memory.
     */
    public void write(Word offset, UByte val) {
        memory[offset.get()] = val.get();
    }

    /**
     * Single byte write to memory.
     */
    public void write(int offset, int val) {
        memory[offset] = val & 0xff;
    }

}
