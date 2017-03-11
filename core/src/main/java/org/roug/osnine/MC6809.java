package org.roug.osnine;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MC6809 extends USimMotorola {

    private static final int IMMEDIATE = 0;
    private static final int RELATIVE = 0;
    private static final int INHERENT = 1;
    private static final int EXTENDED = 2;
    private static final int DIRECT = 3;
    private static final int INDEXED = 4;

    protected int mode;

    /** Set to true to disassemble executed instruction. */
    private boolean traceInstructions;

    /** Stack pointer U. */
    public final Word u = new Word("U");
    /** Stack pointer S. */
    public final Word s = new Word("S");
    /** Index register X. */
    public final Word x = new Word("X");
    /** Index register Y. */
    public final Word y = new Word("Y");

    /** Direct Page register. */
    public final UByte dp = new UByte("DP");
    /** Accumulater A. */
    public final UByte a = new UByte("A");
    /** Accumulater B. */
    public final UByte b = new UByte("B");
    /** Accumulater D. Combined from A and B. */
    public final RegisterD d = new RegisterD(a, b);

    /** Condiction codes. */
    public final RegisterCC cc = new RegisterCC();

    /** Prevent NMI handling. */
    private boolean inhibitNMI;

    /** Did the CPU receive an NMI? */
    private boolean receivedNMI;

    /** Did the CPU receive an FIRQ? */
    private boolean receivedFIRQ;

    /** Did the CPU receive an IRQ? */
    private boolean receivedIRQ;

    private static final Logger LOGGER = LoggerFactory.getLogger(MC6809.class);

    private DisAssembler disAsm = null;

    /**
     * Accept an NMI signal.
     */
    public void signalNMI() {
        if (!inhibitNMI) {
            receivedNMI = true;
        }
    }

    /**
     * Accept an FIRQ signal.
     */
    public void signalFIRQ() {
        if (!cc.isSetF()) {
            receivedFIRQ = true;
        }
    }

    /**
     * Accept an IRQ signal.
     */
    public void signalIRQ() {
        if (!cc.isSetI()) {
            receivedIRQ = true;
        }
    }

    /**
     * Constructor: Allocate 65.536 bytes of memory and reset the CPU.
     */
    public MC6809() {
        super();
        allocate_memory(0xfff0, 16);  // For interrupt vectors

        String traceInset = System.getProperty("mc6809.trace", "false");
        if ("true".equalsIgnoreCase(traceInset)) {
            disAsm = new DisAssembler(this);
        }
        reset();
    }

    /**
     * Constructor: Allocate memory.
     */
    public MC6809(int memorySize) {
        this();
        allocate_memory(0, memorySize);
    }

    /**
     * Reset the simulator. Program counter is set to the content for the top
     * two bytes in memory. Direct page register is set to 0.
     */
    public void reset() {
        pc.set(read_word(0xfffe));
        dp.set(0x00);      // Direct page register = 0x00
        cc.clear();      // Clear all flags
        cc.setI(1);       // IRQ disabled
        cc.setF(1);       // FIRQ disabled
        inhibitNMI = true;  // FIXME: Set to false the first time something is loaded into S.
    }

    /**
     * Print out status.
     */
    public void status() {
        LOGGER.debug("PC:{} A:{} B:{}", pc, a, b);
    }

    /**
     * Execute one instruction.
     */
    public void execute() {
        if (disAsm != null) {
            disAsm.disasmPC();
        }
        ir = fetch();

        // Select addressing mode
        switch (ir & 0xf0) {
            case 0x00: case 0x90: case 0xd0:
                mode = DIRECT; break;
            case 0x20:
                mode = RELATIVE; break;
            case 0x30: case 0x40: case 0x50:
                if (ir < 0x34) {
                    mode = INDEXED;
                } else if (ir < 0x38) {
                    mode = IMMEDIATE;
                } else {
                    mode = INHERENT;
                }
                break;
            case 0x60: case 0xa0: case 0xe0:
                mode = INDEXED; break;
            case 0x70: case 0xb0: case 0xf0:
                mode = EXTENDED; break;
            case 0x80: case 0xc0:
                if (ir == 0x8d) {
                    mode = RELATIVE;
                } else {
                    mode = IMMEDIATE;
                }
                break;
            case 0x10:
                switch (ir & 0x0f) {
                    case 0x02: case 0x03: case 0x09:
                    case 0x0d: case 0x0e: case 0x0f:
                        mode = INHERENT; break;
                    case 0x06: case 0x07:
                        mode = RELATIVE; break;
                    case 0x0a: case 0x0c:
                        mode = IMMEDIATE; break;
                    case 0x00: case 0x01:
                        ir <<= 8;
                        ir |= fetch();
                        switch (ir & 0xf0) {
                            case 0x20:
                                mode = RELATIVE; break;
                            case 0x30:
                                mode = INHERENT; break;
                            case 0x80: case 0xc0:
                                mode = IMMEDIATE; break;
                            case 0x90: case 0xd0:
                                mode = DIRECT; break;
                            case 0xa0: case 0xe0:
                                mode = INDEXED; break;
                            case 0xb0: case 0xf0:
                                mode = EXTENDED; break;
                        }
                        break;
                }
                break;
        }

        // Select instruction
        switch (ir) {
            case 0x3a:
                abx(); break;
            case 0x89: case 0x99: case 0xa9: case 0xb9:
                adca(); break;
            case 0xc9: case 0xd9: case 0xe9: case 0xf9:
                adcb(); break;
            case 0x8b: case 0x9b: case 0xab: case 0xbb:
                adda(); break;
            case 0xcb: case 0xdb: case 0xeb: case 0xfb:
                addb(); break;
            case 0xc3: case 0xd3: case 0xe3: case 0xf3:
                addd(); break;
            case 0x84: case 0x94: case 0xa4: case 0xb4:
                anda(); break;
            case 0xc4: case 0xd4: case 0xe4: case 0xf4:
                andb(); break;
            case 0x1c:
                andcc(); break;
            case 0x47:
                asra(); break;
            case 0x57:
                asrb(); break;
            case 0x07: case 0x67: case 0x77:
                asr(); break;
            case 0x24:
                bcc(); break;
            case 0x25:
                bcs(); break;
            case 0x27:
                beq(); break;
            case 0x2c:
                bge(); break;
            case 0x2e:
                bgt(); break;
            case 0x22:
                bhi(); break;
            case 0x85: case 0x95: case 0xa5: case 0xb5:
                bita(); break;
            case 0xc5: case 0xd5: case 0xe5: case 0xf5:
                bitb(); break;
            case 0x2f:
                ble(); break;
            case 0x23:
                bls(); break;
            case 0x2d:
                blt(); break;
            case 0x2b:
                bmi(); break;
            case 0x26:
                bne(); break;
            case 0x2a:
                bpl(); break;
            case 0x20:
                bra(); break;
            case 0x16:
                lbra(); break;
            case 0x21:
                brn(); break;
            case 0x8d:
                bsr(); break;
            case 0x17:
                lbsr(); break;
            case 0x28:
                bvc(); break;
            case 0x29:
                bvs(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x4f:
            case 0x4f: case 0x4e:
                clra(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x5f:
            case 0x5f: case 0x5e:
                clrb(); break;
            case 0x0f: case 0x6f: case 0x7f:
                clr(); break;
            case 0x81: case 0x91: case 0xa1: case 0xb1:
                cmpa(); break;
            case 0xc1: case 0xd1: case 0xe1: case 0xf1:
                cmpb(); break;
            case 0x1083: case 0x1093: case 0x10a3: case 0x10b3:
                cmpd(); break;
            case 0x118c: case 0x119c: case 0x11ac: case 0x11bc:
                cmps(); break;
            case 0x8c: case 0x9c: case 0xac: case 0xbc:
                cmpx(); break;
            case 0x1183: case 0x1193: case 0x11a3: case 0x11b3:
                cmpu(); break;
            case 0x108c: case 0x109c: case 0x10ac: case 0x10bc:
                cmpy(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x43:
            case 0x43: case 0x42: case 0x1042:
                coma(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x53:
            case 0x53: case 0x52:
                comb(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x03: case 0x63: case 0x73:
            case 0x03: case 0x62: case 0x63: case 0x73:
                com(); break;
            case 0x19:
                daa(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x4a:
            case 0x4a: case 0x4b:
                deca(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x5a:
            case 0x5a: case 0x5b:
                decb(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x0a: case 0x6a: case 0x7a:
            case 0x0a: case 0x0b: case 0x6a: case 0x6b:
            case 0x7a: case 0x7b:
                dec(); break;
            case 0x88: case 0x98: case 0xa8: case 0xb8:
                eora(); break;
            case 0xc8: case 0xd8: case 0xe8: case 0xf8:
                eorb(); break;
            case 0x1e:
                exg(); break;
            case 0x4c:
                inca(); break;
            case 0x5c:
                incb(); break;
            case 0x0c: case 0x6c: case 0x7c:
                inc(); break;
            case 0x0e: case 0x6e: case 0x7e:
                jmp(); break;
            case 0x9d: case 0xad: case 0xbd:
                jsr(); break;
            case 0x86: case 0x96: case 0xa6: case 0xb6:
                lda(); break;
            case 0xc6: case 0xd6: case 0xe6: case 0xf6:
                ldb(); break;
            case 0xcc: case 0xdc: case 0xec: case 0xfc:
                ldd(); break;
            case 0x10ce: case 0x10de: case 0x10ee: case 0x10fe:
                lds(); break;
            case 0xce: case 0xde: case 0xee: case 0xfe:
                ldu(); break;
            case 0x8e: case 0x9e: case 0xae: case 0xbe:
                ldx(); break;
            case 0x108e: case 0x109e: case 0x10ae: case 0x10be:
                ldy(); break;
            case 0x32:
                leas(); break;
            case 0x33:
                leau(); break;
            case 0x30:
                leax(); break;
            case 0x31:
                leay(); break;
            case 0x48:
                lsla(); break;
            case 0x58:
                lslb(); break;
            case 0x08: case 0x68: case 0x78:
                lsl(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x44:
            case 0x44: case 0x45:
                lsra(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x54:
            case 0x54: case 0x55:
                lsrb(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x04: case 0x64: case 0x74:
            case 0x04: case 0x05: case 0x64: case 0x65:
            case 0x74: case 0x75:
                lsr(); break;
            case 0x3d:
                mul(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x40:
            case 0x40: case 0x41:
                nega(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x50:
            case 0x50: case 0x51:
                negb(); break;
            // BDA - Adding in undocumented 6809 instructions
    //      case 0x00: case 0x60: case 0x70:
            case 0x00: case 0x01: case 0x60: case 0x61:
            case 0x70: case 0x71:
                neg(); break;
            // BDA - Adding in undocumented 6809 instructions
            // NEG/COM combination instruction for direct page
            case 0x02:
                if (cc.getC() == 1)
                    com();
                else
                    neg();
                break;
            case 0x12:
                nop(); break;
            case 0x8a: case 0x9a: case 0xaa: case 0xba:
                ora(); break;
            case 0xca: case 0xda: case 0xea: case 0xfa:
                orb(); break;
            case 0x1a:
                orcc(); break;
            case 0x34:
                pshs(); break;
            case 0x36:
                pshu(); break;
            case 0x35:
                puls(); break;
            case 0x37:
                pulu(); break;
            // BDA - Adding in undocumented 6809 instructions
            case 0x3e:
                reset(); break;
            case 0x49:
                rola(); break;
            case 0x59:
                rolb(); break;
            case 0x09: case 0x69: case 0x79:
                rol(); break;
            case 0x46:
                rora(); break;
            case 0x56:
                rorb(); break;
            case 0x06: case 0x66: case 0x76:
                ror(); break;
            case 0x3b:
                rti(); break;
            case 0x39:
                rts(); break;
            case 0x82: case 0x92: case 0xa2: case 0xb2:
                sbca(); break;
            case 0xc2: case 0xd2: case 0xe2: case 0xf2:
                sbcb(); break;
            case 0x1d:
                sex(); break;
            case 0x97: case 0xa7: case 0xb7:
                sta(); break;
            case 0xd7: case 0xe7: case 0xf7:
                stb(); break;
            case 0xdd: case 0xed: case 0xfd:
                std(); break;
            case 0x10df: case 0x10ef: case 0x10ff:
                sts(); break;
            case 0xdf: case 0xef: case 0xff:
                stu(); break;
            case 0x9f: case 0xaf: case 0xbf:
                stx(); break;
            case 0x109f: case 0x10af: case 0x10bf:
                sty(); break;
            case 0x80: case 0x90: case 0xa0: case 0xb0:
                suba(); break;
            case 0xc0: case 0xd0: case 0xe0: case 0xf0:
                subb(); break;
            case 0x83: case 0x93: case 0xa3: case 0xb3:
                subd(); break;
            case 0x3f:
                swi(); break;
            case 0x103f:
                swi2(); break;
            case 0x113f:
                swi3(); break;
            case 0x1f:
                tfr(); break;
            case 0x4d:
                tsta(); break;
            case 0x5d:
                tstb(); break;
            case 0x0d: case 0x6d: case 0x7d:
                tst(); break;
            case 0x1024:
                lbcc(); break;
            case 0x1025:
                lbcs(); break;
            case 0x1027:
                lbeq(); break;
            case 0x102c:
                lbge(); break;
            case 0x102e:
                lbgt(); break;
            case 0x1022:
                lbhi(); break;
            case 0x102f:
                lble(); break;
            case 0x1023:
                lbls(); break;
            case 0x102d:
                lblt(); break;
            case 0x102b:
                lbmi(); break;
            case 0x1026:
                lbne(); break;
            case 0x102a:
                lbpl(); break;
            case 0x1021:
                lbrn(); break;
            case 0x1028:
                lbvc(); break;
            case 0x1029:
                lbvs(); break;
            default:
                // BDA - make invalid instructions a nop
                // to distinquish between 6309
    //          nop(); break;
                invalid("instruction"); break;
        }

        if (receivedNMI) {
            nmi();
            receivedNMI = false;
        }
        if (receivedFIRQ) {
            firq();
            receivedFIRQ = false;
        }
        if (receivedIRQ) {
            irq();
            receivedIRQ = false;
        }
    }

    public int getSignedByte(int value) {
        if (value < 0x80) {
            return value;
        } else {
            return -((~value & 0x7f) + 1);
        }
    }

    public int getSignedWord(int value) {
        if (value < 0x8000) {
            return value;
        } else {
            return -((~value & 0x7fff) + 1);
        }
    }

    /**
     * Find 16-bit register name in post-byte.
     * 00 = X
     * 01 = Y
     * 10 = U
     * 11 = S
     */
    private Word refreg(int post) {
        post &= 0x60;
        post >>= 5;

        if (post == 0) {
            return x;
        } else if (post == 1) {
            return y;
        } else if (post == 2) {
            return u;
        } else {
            return s;
        }
    }

    /**
     * Get value of referenced 8-bit register.
     * 0x08 = A
     * 0x09 = B
     * 0x0a = CC
     * otherwise DP
     */
    private UByte byterefreg(int r) {
        if (r == 0x08) {
            return a;
        } else if (r == 0x09) {
            return b;
        } else if (r == 0x0a) {
            return cc;
        } else {
            return dp;
        }
    }

    private Word wordrefreg(int r) {
        if (r == 0x00) {
            return d;
        } else if (r == 0x01) {
            return x;
        } else if (r == 0x02) {
            return y;
        } else if (r == 0x03) {
            return u;
        } else if (r == 0x04) {
            return s;
        } else {
            return pc;
        }
    }

    private int fetch_operand() {
        int ret = 0;
        int addr;

        if (mode == IMMEDIATE) {
            ret = fetch();
        } else if (mode == RELATIVE) {
            ret = fetch();
        } else if (mode == EXTENDED) {
            addr = fetch_word();
            ret = read(addr);
        } else if (mode == DIRECT) {
            addr = (dp.intValue() << 8) | fetch();
            ret = read(addr);
        } else if (mode == INDEXED) {
            int post = fetch();
            do_predecrement(post);
            addr = do_effective_address(post);
            ret = read(addr);
            do_postincrement(post);
        } else {
            invalid("addressing mode");
        }

        return ret;
    }

    private int fetch_word_operand() {
        int ret = 0;
        int addr;

        if (mode == IMMEDIATE) {
            ret = fetch_word();
        } else if (mode == RELATIVE) {
            ret = fetch_word();
        } else if (mode == EXTENDED) {
            addr = fetch_word();
            ret = read_word(addr);
        } else if (mode == DIRECT) {
            addr = dp.intValue() << 8 | fetch();
            ret = read_word(addr);
        } else if (mode == INDEXED) {
            int post = fetch();
            do_predecrement(post);
            addr = do_effective_address(post);
            do_postincrement(post);
            ret = read_word(addr);
        } else {
            invalid("addressing mode");
        }

        return ret;
    }

    private int fetch_effective_address() {
        int addr = 0;

        if (mode == EXTENDED) {
            addr = fetch_word();
        } else if (mode == DIRECT) {
            addr = dp.intValue() << 8 | fetch();
        } else if (mode == INDEXED) {
            int post = fetch();
            do_predecrement(post);
            addr = do_effective_address(post);
            do_postincrement(post);
        } else {
            invalid("addressing mode");
        }

        return addr;
    }

    /**
     * Calculate indirect addressing.
     */
    private int do_effective_address(int post) {
        int addr = 0;
        int sOffset;
        int uOffset;

        if ((post & 0x80) == 0x00) {
            addr = refreg(post).intValue() + extend5(post & 0x1f);   // Constant 5-bit offset from register
        } else {
            switch (post & 0x1f) {
                case 0x00:  // Increment by 1 (done elsewhere)
                case 0x02:  // Decrement by 1 (done elsewhere)
                    addr = refreg(post).intValue();
                    break;
                case 0x01:  // Increment by 2 (done elsewhere)
                case 0x03:  // Decrement by 2 (done elsewhere)
                case 0x11:  // Increment by 2 (done elsewhere)
                case 0x13:  // Decrement by 2 (done elsewhere)
                    addr = refreg(post).intValue();
                    break;
                case 0x04:  // Non-Indirect No offset
                case 0x14:  // Indirect No offset
                    addr = refreg(post).intValue();
                    break;
                case 0x05:  // Non-Indirect B-register offset
                case 0x15:  // Indirect B-register offset
                    addr = b.getSigned() + refreg(post).intValue();
                    break;
                case 0x06:  // Non-Indirect A-register offset
                case 0x16:  // Indirect A-register offset
                    addr = a.getSigned() + refreg(post).intValue();
                    break;
                case 0x08:  // Non-Indirect 8-bit offset
                case 0x18:  // Indirect 8-bit offset
                    addr = refreg(post).intValue() + extend8(fetch());
                    break;
                case 0x09:  // Non-Indirect 16-bit offset
                case 0x19:  // Indirect 16-bit offset
                    sOffset = getSignedWord(fetch_word());
                    addr = refreg(post).intValue() + sOffset;
                    break;
                case 0x0b:   // Non-Indirect D-register offset
                case 0x1b:   //  Indirect D-register offset
                    sOffset = refreg(post).getSigned();
                    addr = getSignedWord(d.intValue() + sOffset);
                    break;
                case 0x0c:   // Non-Indirect Constant 8-bit offset from PC
                case 0x1c:   // Indirect Constant 8-bit offset from PC
                    uOffset = extend8(fetch());
                    addr = pc.intValue() + uOffset;
                    break;
                case 0x0d:   // Non-Indirect Constant 16-bit offset from PC
                case 0x1d:   // Indirect Constant 16-bit offset from PC
                    sOffset = getSignedWord(fetch_word());
                    addr = pc.intValue() + sOffset;
                    break;
                case 0x1f:   // Extended indirect
                    addr = fetch_word();
                    break;
                default:
                    invalid("indirect addressing postbyte");
                    break;
            }

            /* Do extra indirection */
            if ((post & 0x10) != 0) {
                addr = read_word(addr);
            }
        }

        return addr;
    }

    // Bit extend operations
    private int extend5(int x) {
        if ((x & 0x10) != 0) {
            return x | 0xffe0;
        } else {
            return x;
        }
    }

    private int extend8(int x) {
        if ((x & 0x80) != 0) {
            return x | 0xff00;
        } else {
            return x;
        }
    }

    private void do_postincrement(int post) {
        switch (post & 0x9f) {
            case 0x80:
                refreg(post).add(1);
                break;
            case 0x90:
                invalid("postincrement");
                break;
            case 0x81: case 0x91:
                refreg(post).add(2);
                break;
        }
    }

    private void do_predecrement(int post) {
        switch (post & 0x9f) {
            case 0x82:
                refreg(post).add(-1);
                break;
            case 0x92:
                invalid("predecrement");
                break;
            case 0x83: case 0x93:
                refreg(post).add(-2);
                break;
        }
    }

    private boolean btst(int x, int n) {
        return (x & (1 << n)) != 0;
    }

    private void setBitZ(Register ref) {
        cc.setZ(ref.intValue() == 0);
    }

    /**
     * Set CC bit N if value is negative.
     */
    private void setBitN(Register ref) {
        cc.setN(ref.btst(ref.getWidth() - 1));
    }

    /**
     * Add Accumulator B into index register X.
     */
    private void abx() {
        x.add(b.intValue());
    }

    private void help_adc(UByte refB) {
        int m = fetch_operand();

        {
            UByte t = UByte.valueOf((refB.intValue() & 0x0f) + (m & 0x0f) + cc.getC());
            cc.setH(t.btst(4));      // Half carry
        }

        {
            UByte t = UByte.valueOf((refB.intValue() & 0x7f) + (m & 0x7f) + cc.getC());
            cc.setV(t.btst(7));      // Bit 7 carry in
        }

        {
            Word t = Word.valueOf(refB.intValue() + m + cc.getC());
            cc.setC(t.btst(8));      // Bit 7 carry out
            refB.set(t.intValue());
        }

    //  cc.bit_v ^= cc.bit_c;
        //cc.bit_n = refB.btst(7);
        setBitN(refB);
        setBitZ(refB);
    }

    /**
     * Add with carry into accumulator A.
     */
    private void adca() {
        help_adc(a);
    }

    /**
     * Add with carry into accumulator B.
     */
    private void adcb() {
        help_adc(b);
    }


    private void help_add(UByte refB) {
        int m = fetch_operand();

        {
            UByte t = UByte.valueOf((refB.intValue() & 0x0f) + (m & 0x0f));
            cc.setH(t.btst(4));      // Half carry
        }

        {
            UByte t = UByte.valueOf((refB.intValue() & 0x7f) + (m & 0x7f));
            cc.setV(t.btst(7));      // Bit 7 carry in
        }

        {
            Word t = Word.valueOf(refB.intValue() + m);
            cc.setC(t.btst(8));      // Bit 7 carry out
            refB.set(t.intValue() & 0xff);
        }

    //  cc.bit_v ^= cc.bit_c;
        cc.setN(refB.btst(7));
        setBitZ(refB);
    }

    /**
     * Add memory into accumulator A.
     */
    private void adda() {
        help_add(a);
    }

    /**
     * Add memory into accumulator B.
     */
    private void addb() {
        help_add(b);
    }

    /**
     * Add memory into accumulator D.
     */
    private void addd() {
        int m = fetch_word_operand();

        int newD = d.intValue() + m;
        d.set(newD);
        //cc.bit_v = btst(intD ^ m ^ t ^ (t >> 1), 15);
        cc.setC(newD > 0xffff);
        cc.setV(!cc.isSetC());      // Bit 15 carry in

    //  cc.bit_v ^= cc.bit_c;
        cc.setN(d.btst(15));
        setBitZ(d);
    }

    private void help_and(UByte refB) {
        refB.set(refB.intValue() & fetch_operand());
        cc.setN(refB.btst(7));
        setBitZ(refB);
        cc.setV(0);
    }

    /**
     * AND memory into accumulator A.
     */
    private void anda() {
        help_and(a);
    }

    /**
     * AND memory into accumulator B.
     */
    private void andb() {
        help_and(b);
    }

    /**
     * AND Immediate Data into Condition Code register.
     */
    private void andcc() {
        cc.set(cc.intValue() & fetch());
    }

    private void help_asr(UByte refB) {   
        cc.setC(refB.btst(0));
        refB.set(refB.intValue() >> 1);    // Shift word right
        cc.setN(refB.btst(6));
        if (cc.getN() != 0) {
            refB.bset(7);
        }
        setBitZ(refB);
    }

    /**
     * Arithmetic Shift Right accumulator A.
     */
    private void asra() {
        help_asr(a);
    }

    /**
     * Arithmetic Shift Right accumulator B.
     */
    private void asrb() {
        help_asr(b);
    }

    /**
     * Arithmetic Shift Right memory byte.
     */
    private void asr() {
        int addr = fetch_effective_address();
        int m = read(addr);

        UByte mbyte = UByte.valueOf(m);
        help_asr(mbyte);
        write(addr, mbyte);
    }


    /**
     * Branch on Carry Clear.
     */
    private void bcc() {
        do_br(!cc.isSetC());
    }

    /**
     * Long Branch on Carry Clear.
     */
    private void lbcc() {
        do_lbr(!cc.isSetC());
    }

    /**
     * Branch on Carry Set.
     */
    private void bcs() {
        do_br(cc.isSetC());
    }

    /**
     * Long Branch on Carry Set.
     */
    private void lbcs() {
        do_lbr(cc.isSetC());
    }

    private void beq() {
        do_br(cc.isSetZ());
    }

    private void lbeq() {
        do_lbr(cc.isSetZ());
    }

    //FIXME: test logic
    private void bge() {
        //do_br(!(cc.bit_n ^ cc.bit_v));
        do_br(cc.isSetN() == cc.isSetV());
    }

    //FIXME: test logic
    private void lbge() {
        //do_lbr(!(cc.bit_n ^ cc.bit_v));
        do_lbr(cc.isSetN() == cc.isSetV());
    }

    private void bgt() {
        //do_br(!(cc.bit_z | (cc.bit_n ^ cc.bit_v)));
        do_br(!cc.isSetZ() && (cc.isSetN() == cc.isSetV()));
    }

    //FIXME: test logic
    private void lbgt() {
        //do_lbr(!(cc.bit_z | (cc.bit_n ^ cc.bit_v)));
        do_lbr(!cc.isSetZ() && (cc.isSetN() == cc.isSetV()));
    }


    private void bhi() {
        do_br(!(cc.isSetC() || cc.isSetZ()));
    }

    private void lbhi() {
        do_lbr(!(cc.isSetC() || cc.isSetZ()));
    }


    private void bita() {
        help_bit(a);
    }

    private void bitb() {
        help_bit(b);
    }

    private void help_bit(UByte arg) {
        UByte t = UByte.valueOf(arg.intValue() & fetch_operand());
        setBitN(t);
        cc.setV(0);
        setBitZ(t);
    }

    private void ble() {
        //do_br(cc.bit_z | (cc.bit_n ^ cc.bit_v));
        do_br(cc.isSetZ() || (cc.isSetN() != cc.isSetV()));
    }

    private void lble() {
        //do_lbr(cc.bit_z | (cc.bit_n ^ cc.bit_v));
        do_lbr(cc.isSetZ() || (cc.isSetN() != cc.isSetV()));
    }

    private void bls() {
        do_br(cc.isSetC() || cc.isSetZ());
    }

    private void lbls() {
        do_lbr(cc.isSetC() || cc.isSetZ());
    }

    private void blt() {
        //do_br(cc.bit_n ^ cc.bit_v);
        do_br(cc.isSetN() != cc.isSetV());
    }

    private void lblt() {
        //do_lbr(cc.bit_n ^ cc.bit_v);
        do_lbr(cc.isSetN() != cc.isSetV());
    }

    private void bmi() {
        do_br(cc.isSetN());
    }

    private void lbmi() {
        do_lbr(cc.isSetN());
    }

    private void bne() {
        do_br(!cc.isSetZ());
    }

    private void lbne() {
        do_lbr(!cc.isSetZ());
    }

    private void bpl() {
        do_br(!cc.isSetN());
    }

    private void lbpl() {
        do_lbr(!cc.isSetN());
    }

    private void bra() {
        do_br(true);
    }

    private void lbra() {
        do_lbr(true);
    }

    private void brn() {
        do_br(false);
    }

    private void lbrn() {
        do_lbr(false);
    }

    private void bsr() {
        int relAddr = fetch();
        s.add(-1);
        write(s, pc.intValue());
        s.add(-1);
        write(s, (pc.intValue() >> 8));
        pc.add(extend8(relAddr));
    }

    private void lbsr() {
        int relAddr = fetch_word();
        s.add(-1);
        write(s, pc.intValue());
        s.add(-1);
        write(s, (pc.intValue() >> 8));
        pc.add(relAddr);
    }

    private void bvc() {
        do_br(!cc.isSetV());
    }

    private void lbvc() {
        do_lbr(!cc.isSetV());
    }

    private void bvs() {
        do_br(cc.isSetV());
    }

    private void lbvs() {
        do_lbr(cc.isSetV());
    }

    private void clra() {
        help_clr(a);
    }

    private void clrb() {
        help_clr(b);
    }

    private void clr() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_clr(m);
        write(addr, m);
    }

    private void help_clr(UByte refB) {
        cc.setN(0);
        cc.setZ(1);
        cc.setV(0);
        cc.setC(0);
        refB.set(0);
    }

    private void cmpa() {
        help_cmp(a);
    }

    private void cmpb() {
        help_cmp(b);
    }

    private void help_cmp(UByte reg) {
        int m = fetch_operand();
        int t = reg.intValue() - m;
         
        cc.setH((t & 0x0f) < (m & 0x0f));

        int tmp = reg.intValue() ^ m ^ t ^ (t >> 1);
        cc.setV(btst(tmp, 7));
        cc.setC(btst(t, 8));
         
        cc.setN(btst(t, 7));
        cc.setZ(t == 0 ? 1 : 0);
    }

    private void cmpd() {
        help_cmp(d);
    }

    private void cmpx() {
        help_cmp(x);
    }

    private void cmpy() {
        help_cmp(y);
    }

    private void cmpu() {
        help_cmp(u);
    }

    private void cmps() {
        help_cmp(s);
    }

    private void help_cmp(Word reg) {
        int m = fetch_word_operand();
        int t = reg.intValue() - m;
         
        int tmp = reg.intValue() ^ m ^ t ^ (t >> 1);
        cc.setV(btst(tmp, 15));
        cc.setC(btst(t, 16));
         
        cc.setN(btst(t, 15));
        cc.setZ(t == 0 ? 1 : 0);
    }

    private void coma() {
        help_com(a);
    }

    private void comb() {
        help_com(b);
    }

    private void com() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_com(m);
        write(addr, m);
    }

    private void help_com(UByte tx) {
        tx.set(~tx.intValue());
        cc.setC(1);
        cc.setV(0);
        setBitN(tx);
        setBitZ(tx);
    }

    private void daa() {
        int c = 0;
        int lsn = (a.intValue() & 0x0f);
        int msn = (a.intValue() & 0xf0) >> 4;

        if (cc.isSetH() || (lsn > 9)) {
            c |= 0x06;
        }

        if (cc.isSetC() ||
            (msn > 9) ||
            ((msn > 8) && (lsn > 9))) {
            c |= 0x60;
        }

        {
            int t = a.intValue() + c;
            cc.setC(btst(t, 8));
            a.set(t);
        }

        setBitN(a);
        setBitZ(a);
    }

    private void deca() {
        help_dec(a);
    }

    private void decb() {
        help_dec(b);
    }

    private void dec() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_dec(m);
        write(addr, m);
    }

    private void help_dec(UByte x) {
        cc.setV(x.intValue() == 0x80);
        x.set(x.intValue() - 1);
        setBitN(x);
        setBitZ(x);
    }

    private void eora() {
        help_eor(a);
    }

    private void eorb() {
        help_eor(b);
    }

    private void help_eor(UByte x) {
        x.set(x.intValue() ^ fetch_operand());
        cc.setV(0);
        setBitN(x);
        setBitZ(x);
    }

    static void swap(UByte r1, UByte r2) {
        UByte t = new UByte();
        t.set(r1.intValue());
        r1.set(r2.intValue());
        r2.set(t.intValue());
    }

    static void swap(Word r1, Word r2) {
        Word t = new Word();
        t.set(r1.intValue());
        r1.set(r2.intValue());
        r2.set(t.intValue());
    }

    private void exg() {
        int r1, r2;
        int w = fetch();
        r1 = (w & 0xf0) >> 4;
        r2 = (w & 0x0f) >> 0;
        if (r1 <= 5) {
            if (r2 > 5) {
                invalid("exchange register");
                return;
            }
            swap(wordrefreg(r2), wordrefreg(r1));
        } else if (r1 >= 8 && r2 <= 11) {
            if (r2 < 8 || r2 > 11) {
                invalid("exchange register");
                return;
            }
            swap(byterefreg(r2), byterefreg(r1));
        } else  {
            invalid("exchange register");
            return;
        }
    }

    /**
     * Fast hardware interrupt (FIRQ).
     * The <em>fast interrupt request</em> is similar to the IRQ, as it is maskable by
     * setting the F bit in the condition code register to 1. When an FIRQ is
     * received, only the PC and condition code register are saved on the hardware
     * stack. The E bit is not set, because the entire machine state has not
     * been saved. The PC for the FIRQ handler is fetched from locations
     * FFF6:FFF7. Both the F and the I bits are set to 1 to prevent any more
     * interrupts.
     *
     * The fast interrupt request executes much more quickly than the NMI
     * or IRQ, because only three bytes are pushed onto the stack. The FIRQ
     * takes ten cycles to execute. The NMI and IRQ require nineteen. The fast
     * interrupt request is very useful when speed is essential, but the registers
     * are not used extensively. If a reqister is used, it must first be pushed and
     * then pulled, before execution of the RTI instruction. The RTI restores
     * the condition code register and the PC of the interrupted program.
     */
    private void firq() {
        if (cc.isSetF()) {
            return;
        }
        help_psh(0x81, s, u);
        cc.setF(1);
        cc.setI(1);
        pc.set(read_word(0xfff6));
    }

    private void inca() {
        help_inc(a);
    }

    private void incb() {
        help_inc(b);
    }

    private void inc() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_inc(m);
        write(addr, m);
    }

    private void help_inc(UByte x) {
        cc.setV(x.intValue() == 0x7f);
        x.set(x.intValue() + 1);
        setBitN(x);
        setBitZ(x);
    }

    /**
     * Hardware interrupt (IRQ).
     * When an IRQ occurs and the I bit is zero, the PC and all the registers
     * (except S) are pushed onto the hardware stack. The PC of the IRQ
     * handler is fetched from memory locations FFF8:FFF9. This process is
     * the same for the NMI. The E bit in the condition register is set to 1,
     * because the entire machine state is saved; the I bit is set to 1 to prevent
     * any more IRQs. It is usually not necessary to be able to handle more than
     * one IRQ at a time. However, the I bit may be cleared by the program and
     * more IRQs accepted if necessary.
     *
     * The IRQ handler is terminated with an RTI instruction. This instruction
     * restores all the registers from the stack and the PC of the interrupted
     * program.
     */
    private void irq() {
        if (cc.isSetI()) {
            return;
        }
        cc.setE(1);
        help_psh(0xff, s, u);
        cc.setF(1);
        cc.setI(1);
        pc.set(read_word(0xfff8));
    }

    private void jmp() {
        pc.set(fetch_effective_address());
    }

    private void jsr() {
        int addr = fetch_effective_address();
        s.add(-1);
        write(s, pc.intValue());
        s.add(-1);
        write(s, pc.intValue() >> 8);
        pc.set(addr);
    }

    private void lda() {
        help_ld(a);
    }

    private void ldb() {
        help_ld(b);
    }

    private void help_ld(UByte regB) {
        regB.set(fetch_operand());
        setBitN(regB);
        cc.setV(0);
        setBitZ(regB);
    }

    private void ldd() {
        help_ld(d);
    }

    private void ldx() {
        help_ld(x);
    }

    private void ldy() {
        help_ld(y);
    }

    private void lds() {
        help_ld(s);
    }

    private void ldu() {
        help_ld(u);
    }

    private void help_ld(Word regW) {
        regW.set(fetch_word_operand());
        setBitN(regW);
        cc.setV(0);
        setBitZ(regW);
    }

    private void leas() {
        s.set(fetch_effective_address());
    }

    private void leau() {
        u.set(fetch_effective_address());
    }

    private void leax() {
        x.set(fetch_effective_address());
        setBitZ(x);
    }

    private void leay() {
        y.set(fetch_effective_address());
        setBitZ(y);
    }

    private void lsla() {
        help_lsl(a);
    }

    private void lslb() {
        help_lsl(b);
    }

    private void lsl() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_lsl(m);
        write(addr, m);
    }

    private void help_lsl(UByte regB) {
        cc.setC(regB.btst(7));
        cc.setV(regB.btst(7) ^ regB.btst(6));
        regB.set(regB.intValue() << 1);
        setBitN(regB);
        setBitZ(regB);
    }

    private void lsra() {
        help_lsr(a);
    }

    private void lsrb() {
        help_lsr(b);
    }

    private void lsr() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_lsr(m);
        write(addr, m);
    }

    private void help_lsr(UByte regB) {
        cc.setC(regB.btst(0));
        regB.set(regB.intValue() >> 1); // Shift word right
        cc.setN(0);
        setBitZ(regB);
    }

    private void mul() {
        d.set(a.intValue() * b.intValue());
        cc.setC(b.btst(7));
        setBitZ(d);
    }

    private void nega() {
        help_neg(a);
    }

    private void negb() {
        help_neg(b);
    }

    private void neg() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_neg(m);
        write(addr, m);
    }

    private void help_neg(UByte regB) {
        cc.setV(regB.intValue() == 0x80);
        {
            int t = ((~regB.intValue()) & 0xff) + 1;
            regB.set(t & 0xff);
        }

        setBitN(regB);
        setBitZ(regB);
        cc.setC(regB.intValue() != 0);
    }

    /**
     * The Non-Maskable Interrupt (NMI).
     * The non-maskable interrup (NMI) cannot be inhibited by the
     * programmer. It is always accepted by the 6809 upon completion of the
     * current instruction, assuminig no bus request was received.
     *
     * The NMI causes the automatic push of the program counter and all
     * other registers (except the S register) onto the hardware stack, S (If an
     * NMI is received during a DMA/BREQ, it will set an internal NMI latch,
     * and be processed at the end of the DMA/BREQ.) A new program counter
     * is loaded from the data in memory locations FFFC and FFFD. The starting
     * address of the NMI handler is stored with the high byte in FFFC and
     * the low byte in FFFD.
     */
    private void nmi() {
        cc.setE(1);
        help_psh(0xff, s, u);
        cc.setF(1);
        cc.setI(1);
        pc.set(read_word(0xfffc));
    }

    /**
     * No operation.
     */
    private void nop() {
    }

    private void ora() {
        help_or(a);
    }

    private void orb() {
        help_or(b);
    }

    private void help_or(UByte regB) {
        regB.set(regB.intValue() | fetch_operand());
        cc.setV(0);
        setBitN(regB);
        setBitZ(regB);
    }

    private void orcc() {
        cc.set(cc.intValue() | fetch_operand());
    }

    private void pshs() {
        help_psh(fetch(), s, u);
    }

    private void pshu() {
        help_psh(fetch(), u, s);
    }

    private void help_psh(int w, Word s, Word u) {
        if (btst(w, 7)) {
            s.add(-1);
            write(s, pc.intValue());
            s.add(-1);
            write(s, (pc.intValue() >> 8));
        }
        if (btst(w, 6)) {
            s.add(-1);
            write(s, u.intValue());
            s.add(-1);
            write(s, (u.intValue() >> 8));
        }
        if (btst(w, 5)) {
            s.add(-1);
            write(s, y.intValue());
            s.add(-1);
            write(s, (y.intValue() >> 8));
        }
        if (btst(w, 4)) {
            s.add(-1);
            write(s, x.intValue());
            s.add(-1);
            write(s, (x.intValue() >> 8));
        }
        if (btst(w, 3)) {
            s.add(-1);
            write(s, dp.intValue());
        }
        if (btst(w, 2)) {
            s.add(-1);
            write(s, b.intValue());
        }
        if (btst(w, 1)) {
            s.add(-1);
            write(s, a.intValue());
        }
        if (btst(w, 0)) {
            s.add(-1);
            write(s, cc.intValue());
        }
    }

    /**
     * PULS: Pull Registers from Hardware Stack.
     * The stack grows downwards, and this means that when you PULL, the
     * stack pointer is increased.
     */
    private void puls() {
        int w = fetch();
        help_pul(w, s, u);
    }

    private void pulu() {
        int w = fetch();
        help_pul(w, u, s);
    }

    private void help_pul(int w, Word s, Word u) {
        if (btst(w, 0)) {
            cc.set(read(s));
            s.add(1);
        }
        if (btst(w, 1)) {
            a.set(read(s));
            s.add(1);
        }
        if (btst(w, 2)) {
            b.set(read(s));
            s.add(1);
        }
        if (btst(w, 3)) {
            dp.set(read(s));
            s.add(1);
        }
        if (btst(w, 4)) {
            x.set(read_word(s));
            s.add(2);
        }
        if (btst(w, 5)) {
            y.set(read_word(s));
            s.add(2);
        }
        if (btst(w, 6)) {
            u.set(read_word(s));
            s.add(2);
        }
        if (btst(w, 7)) {
            pc.set(read_word(s));
            s.add(2);
        }
    }

    private void rola() {
        help_rol(a);
    }

    private void rolb() {
        help_rol(b);
    }

    private void rol() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_rol(m);
        write(addr, m);
    }

    private void help_rol(UByte regB) {
        boolean oc = cc.isSetC();
        cc.setV(regB.btst(7) ^ regB.btst(6));
        cc.setC(regB.btst(7));
        regB.set(regB.intValue() << 1);
        if (oc) {
            regB.bset(0);
        }
        setBitN(regB);
        setBitZ(regB);
    }

    private void rora() {
        help_ror(a);
    }

    private void rorb() {
        help_ror(b);
    }

    private void ror() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_ror(m);
        write(addr, m);
    }

    private void help_ror(UByte regB) {
        boolean oc = cc.isSetC();
        cc.setC(regB.btst(0));
        regB.set(regB.intValue() >> 1);
        if (oc) {
            regB.bset(7);
        }
        setBitN(regB);
        setBitZ(regB);
    }

    private void rti() {
        help_pul(0x01, s, u);
        if (cc.isSetE()) {
            help_pul(0xfe, s, u);
        }
    }

    private void rts() {
        pc.set(read_word(s));
        s.add(2);
    }

    private void sbca() {
        help_sbc(a);
    }

    private void sbcb() {
        help_sbc(b);
    }

    private void help_sbc(UByte regB) {
        int m = fetch_operand();
        int t = regB.intValue() - m - cc.getC();
         
        cc.setH(((t & 0x0f) < (m & 0x0f))); // half-carry
        cc.setV(btst(regB.intValue() ^ m ^ t ^ (t >> 1), 7));
        cc.setC(btst(t, 8));
         
        cc.setN(btst(t, 7));
        cc.setZ(t == 0);
        regB.set(t);
    }

    private void sex() {
        setBitN(b);
        a.set(cc.isSetN() ? 255 : 0);
        setBitZ(a);
    }

    private void sta() {
        help_st(a);
    }

    private void stb() {
        help_st(b);
    }

    private void help_st(UByte data) {
        int addr = fetch_effective_address();
        write(addr, data);
        cc.setV(0);
        setBitN(data);
        setBitZ(data);
    }

    private void std() {
        help_st(d);
    }

    private void stx() {
        help_st(x);
    }

    private void sty() {
        help_st(y);
    }

    private void sts() {
        help_st(s);
    }

    private void stu() {
        help_st(u);
    }

    private void help_st(Word dataW) {
        int addr = fetch_effective_address();
        write_word(addr, dataW.intValue());
        cc.setV(0);
        setBitN(dataW);
        setBitZ(dataW);
    }

    private void suba() {
        help_sub(a);
    }

    private void subb() {
        help_sub(b);
    }

    private void help_sub(UByte regB) {
        int m = fetch_operand();
        int t = regB.intValue() - m;
         
        cc.setV(btst(regB.intValue() ^ m ^ t ^ (t >> 1), 7));
        cc.setC(btst(t, 8));
         
        cc.setN(btst(t, 7));
        cc.setZ(t == 0);
        regB.set(t);
    }

    private void subd() {
        int m = fetch_word_operand();
        int t = d.intValue() - m;
         
        cc.setV(btst(d.intValue() ^ m ^ t ^ (t >> 1), 15));
        cc.setC(btst(t, 16));
         
        cc.setN(btst(t, 15));
        cc.setZ(t == 0);
        d.set(t);
    }

    protected void swi() {
        cc.setE(1);
        help_psh(0xff, s, u);
        cc.setF(1);
        cc.setI(1);
        pc.set(read_word(0xfffa));
    }

    protected void swi2() {
        cc.setE(1);
        help_psh(0xff, s, u);
        pc.set(read_word(0xfff4));
    }

    protected void swi3() {
        cc.setE(1);
        help_psh(0xff, s, u);
        pc.set(read_word(0xfff2));
    }

    private void tfr() {
        int w = fetch();
        int r1 = (w & 0xf0) >> 4;
        int r2 = (w & 0x0f) >> 0;
        if (r1 <= 5) {
            if (r2 > 5) {
                invalid("transfer register");
                return;
            }
            wordrefreg(r2).set(wordrefreg(r1).intValue());
        } else if (r1 >= 8 && r2 <= 11) {
            if (r2 < 8 || r2 > 11) {
                invalid("transfer register");
                return;
            }
            byterefreg(r2).set(byterefreg(r1).intValue());
        } else  {
            invalid("transfer register");
            return;
        }
    }

    private void tsta() {
        help_tst(a);
    }

    private void tstb() {
        help_tst(b);
    }

    private void tst() {
        int addr = fetch_effective_address();
        UByte m = UByte.valueOf(read(addr));
        help_tst(m);
    }

    private void help_tst(UByte dataB) {
        cc.setV(0);
        setBitN(dataB);
        setBitZ(dataB);
    }

    private void do_br(boolean test) {
        int offset = extend8(fetch_operand());
        if (test) {
            pc.add(offset);
        }
    }

    private void do_lbr(boolean test) {
        int offset = fetch_word_operand();
        if (test) {
            pc.add(offset);
        }
    }

}