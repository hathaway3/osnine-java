package org.roug.usim;

/**
 * Interface for sending a one bit signal to another component.
 * Used for lambdas.
 */
public interface BitReceiver {
    void send(boolean state);
}

