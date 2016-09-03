package org.roug.osnine.os9;

import java.io.RandomAccessFile;
import java.io.FileNotFoundException;
import java.nio.file.Paths;

class DevDrvTerm extends DevDrvr {

    /* The UNIX device it coresponds to -- like /dev/tty */
    private String device;

    public DevDrvTerm(final String mntpnt, final String args) {
        super(mntpnt);
	device = args;
    }

    @Override
    public PathDesc open(final String path, int mode, boolean create) {
	PDTerm fd = null;
        try {
            fd = new PDTerm(Paths.get(device), "r");
            fd.setDriver(this);
        } catch (FileNotFoundException e) {
            errorcode = ErrCodes.E_BPNam;
        }
	return fd;
    }

    public PathDesc open(RandomAccessFile unixfp) {
	PDTerm fd = null;
        fd = new PDTerm(unixfp);
        fd.setDriver(this);
	return fd;
    }


}
