public class TestLogger {

    public static void main(String[] args) {

        // Get instance first time
        Logger logger1 = Logger.getInstance();

        // Get instance second time
        Logger logger2 = Logger.getInstance();

        // Check both are same
        if (logger1 == logger2) {
            System.out.println("SUCCESS: Only one instance exists!");
        } else {
            System.out.println("FAILED: Multiple instances!");
        }

        // Use logger
        logger1.log("Application has started");
        logger2.log("User logged in successfully");
    }
}