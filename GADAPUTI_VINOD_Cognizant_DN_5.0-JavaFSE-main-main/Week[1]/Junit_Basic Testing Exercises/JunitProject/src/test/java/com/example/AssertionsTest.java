package com.example;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Exercise 3: Assertions in JUnit
 * This test class demonstrates various JUnit assertions for validating test results
 */
public class AssertionsTest {

    /**
     * Test case demonstrating assertEquals assertion
     * Validates that two values are equal
     */
    @Test
    public void testAssertEquals() {
        assertEquals("Values should be equal", 5, 2 + 3);
        assertEquals("String comparison", "JUnit", "JUnit");
        assertEquals("Double with delta", 10.5, 10.5, 0.01);
    }

    /**
     * Test case demonstrating assertTrue assertion
     * Validates that a condition is true
     */
    @Test
    public void testAssertTrue() {
        assertTrue("5 > 3 should be true", 5 > 3);
        assertTrue("10 is greater than 5", 10 > 5);
        boolean condition = true;
        assertTrue("Condition should be true", condition);
    }

    /**
     * Test case demonstrating assertFalse assertion
     * Validates that a condition is false
     */
    @Test
    public void testAssertFalse() {
        assertFalse("5 < 3 should be false", 5 < 3);
        assertFalse("10 is not less than 5", 10 < 5);
        boolean condition = false;
        assertFalse("Condition should be false", condition);
    }

    /**
     * Test case demonstrating assertNull assertion
     * Validates that an object is null
     */
    @Test
    public void testAssertNull() {
        String nullString = null;
        assertNull("String should be null", nullString);
        Object nullObject = null;
        assertNull("Object should be null", nullObject);
    }

    /**
     * Test case demonstrating assertNotNull assertion
     * Validates that an object is not null
     */
    @Test
    public void testAssertNotNull() {
        String str = "Hello";
        assertNotNull("String should not be null", str);
        Object obj = new Object();
        assertNotNull("Object should not be null", obj);
    }

    /**
     * Test case demonstrating assertSame assertion
     * Validates that two references point to the same object
     */
    @Test
    public void testAssertSame() {
        Object obj1 = new Object();
        Object obj2 = obj1; // Same reference
        assertSame("References should be the same", obj1, obj2);
    }

    /**
     * Test case demonstrating assertNotSame assertion
     * Validates that two references point to different objects
     */
    @Test
    public void testAssertNotSame() {
        Object obj1 = new Object();
        Object obj2 = new Object(); // Different reference
        assertNotSame("References should be different", obj1, obj2);
    }

    /**
     * Test case demonstrating fail assertion
     * This assertion always fails - useful for testing exception handling
     */
    @Test
    public void testAssertFail() {
        try {
            int result = 10 / 2;
            assertEquals("Result should be 5", 5, result);
            // If we reach here with unexpected value, fail the test
        } catch (Exception e) {
            fail("Should not throw an exception: " + e.getMessage());
        }
    }

    /**
     * Combined assertions test
     * This test demonstrates using multiple assertions in a single test
     */
    @Test
    public void testAllAssertions() {
        // Test data
        int expectedValue = 5;
        int actualValue = 2 + 3;
        String expectedString = "JUnit";
        String actualString = "JUnit";
        Object obj = new Object();

        // Assert equals
        assertEquals("Values should be equal", expectedValue, actualValue);

        // Assert true
        assertTrue("5 > 3 should be true", 5 > 3);

        // Assert false
        assertFalse("5 < 3 should be false", 5 < 3);

        // Assert null
        assertNull("Null value should be null", null);

        // Assert not null
        assertNotNull("New object should not be null", obj);

        // Assert same
        Object reference = obj;
        assertSame("References should be the same", obj, reference);

        // Assert string equality
        assertEquals("Strings should match", expectedString, actualString);
    }

    /**
     * Test demonstrating array assertions
     */
    @Test
    public void testArrayAssertions() {
        int[] expected = {1, 2, 3, 4, 5};
        int[] actual = {1, 2, 3, 4, 5};
        
        // Assert array equality
        assertArrayEquals("Arrays should be equal", expected, actual);
    }
}
