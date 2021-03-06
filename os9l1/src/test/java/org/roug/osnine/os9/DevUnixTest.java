package org.roug.osnine.os9;

import java.io.IOException;
import java.io.File;
import java.nio.file.Path;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

/**
 * The Device driver that interfaces to a UNIX filesystem.
 */
public class DevUnixTest {

    /**
     * Read 10 bytes and see if it is done correctly.
     */
    @Test
    public void testRead() {
        String driveLocation = System.getProperty("outputDirectory");
        //System.out.println(driveLocation);
        DevUnix dev = new DevUnix("/dd", driveLocation); // Default drive
        PathDesc pd = dev.open("/dd/datamodule", AccessCodes.READ, false);
        //System.out.println(Util.getErrorMessage(dev.getErrorCode()));
        assertNotNull(pd);
        byte[] buf = new byte[100];
        int len = pd.read(buf, 10);
        assertEquals(10, len);
        assertEquals(0x87, buf[0] + 256);
        assertEquals(0xCD, buf[1] + 256);
        assertEquals(0x01, buf[2]);
        assertEquals(0x00, buf[3]);
    }

    /**
     * Read 10 bytes and see if it is done correctly.
     */
    @Test
    public void openCaseInsensitive() {
        String driveLocation = System.getProperty("outputDirectory");
        //System.out.println(driveLocation);
        DevUnix dev = new DevUnix("/dd", driveLocation); // Default drive
        PathDesc pd = dev.open("/dd/DataModule", AccessCodes.READ, false);
        //System.out.println(Util.getErrorMessage(dev.getErrorCode()));
        assertNotNull(pd);
        byte[] buf = new byte[100];
        int len = pd.read(buf, 10);
        assertEquals(10, len);
        assertEquals(0x87, buf[0] + 256);
        assertEquals(0xCD, buf[1] + 256);
        assertEquals(0x01, buf[2]);
        assertEquals(0x00, buf[3]);
    }

    /**
     * Create a new file.
     */
    @Test
    public void testCreate() {
        int len = 0;
        byte[] buf = new byte[20];
        String newFile = "/dd/newfile";

        String driveLocation = System.getProperty("outputDirectory");
        //System.out.println(driveLocation);
        DevUnix dev = new DevUnix("/dd", driveLocation); // Default drive

        PathDesc pd = dev.open("/dd/newfile", AccessCodes.WRITE, true);
        //System.out.println(Util.getErrorMessage(dev.getErrorCode()));
        assertNotNull(pd);
        String helloWorld = "Hello World\n";
        System.arraycopy(helloWorld.getBytes(), 0, buf, 0, helloWorld.length());
        len = pd.write(buf, helloWorld.length());
        assertEquals(helloWorld.length(), len);
        pd.close();

        // Test that a open for write truncates
        PathDesc pd1 = dev.open("/dd/newfile", AccessCodes.WRITE, true);
        String hi = "Hi!\n";
        System.arraycopy(hi.getBytes(), 0, buf, 0, hi.length());
        len = pd1.write(buf, hi.length());
        assertEquals(hi.length(), len);
        pd1.close();

        
        PathDesc pd2 = dev.open("/dd/newfile", AccessCodes.READ, false);
        len = pd2.read(buf, 20);
        assertEquals(hi.length(), len);
        pd2.close();

        int delResult = dev.delfile("/dd/newfile");
        assertEquals(0, delResult);
    }

    /**
     * Check case-sensitivity.
     * FIXME: This doesn't work on a Windows system
     */
    @Test
    public void testGetPath() {
        String osName = System.getProperty("os.name", "").toLowerCase();
        if(osName.contains("linux")) {
            File f = new File("/ETC/passwd");
            Path path = DevUnix.findpath(f.toPath(), true);
            assertNotNull(path);
            assertEquals("/etc/passwd", path.toString());
        }
    }

    /**
     * Check case-sensitivity.
     * FIXME: This doesn't work on a Windows system
     */
    @Test
    public void testGetPathLast() {
        String osName = System.getProperty("os.name", "").toLowerCase();
        if(osName.contains("linux")) {
            File f = new File("/ETC/PasswD");
            Path path = DevUnix.findpath(f.toPath(), true);
            assertNotNull(path);
            assertEquals("/etc/passwd", path.toString());
        }
    }
}
