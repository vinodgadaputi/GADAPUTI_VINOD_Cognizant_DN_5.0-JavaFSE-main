
public class Logger {

    // 1. Private static instance of itself
    private static Logger instance;

    // 2. Private constructor
    // Prevents anyone from doing "new Logger()"
    private Logger() {
        System.out.println("Logger instance created.");
    }

    // 3. Public static method to get instance
    public static Logger getInstance() {
        if (instance == null) {
            instance = new Logger(); // Only created ONCE
        }
        return instance;
    }

    // 4. Log method
    public void log(String message) {
        System.out.println("LOG: " + message);
    }
}