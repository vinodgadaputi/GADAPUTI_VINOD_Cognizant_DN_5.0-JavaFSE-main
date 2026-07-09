package com.example;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 * Test class for Calculator using JUnit 4
 */
public class CalculatorTest {

    private Calculator calculator;

    /**
     * Setup method - runs before each test
     * Initializes a new Calculator instance
     */
    @Before
    public void setUp() {
        calculator = new Calculator();
    }

    /**
     * Test case for addition
     */
    @Test
    public void testAdd() {
        int result = calculator.add(5, 3);
        assertEquals("5 + 3 should equal 8", 8, result);
    }

    /**
     * Test case for addition with negative numbers
     */
    @Test
    public void testAddNegative() {
        int result = calculator.add(-5, -3);
        assertEquals("-5 + -3 should equal -8", -8, result);
    }

    /**
     * Test case for subtraction
     */
    @Test
    public void testSubtract() {
        int result = calculator.subtract(10, 3);
        assertEquals("10 - 3 should equal 7", 7, result);
    }

    /**
     * Test case for multiplication
     */
    @Test
    public void testMultiply() {
        int result = calculator.multiply(4, 5);
        assertEquals("4 * 5 should equal 20", 20, result);
    }

    /**
     * Test case for division
     */
    @Test
    public void testDivide() {
        double result = calculator.divide(10, 2);
        assertEquals("10 / 2 should equal 5", 5.0, result, 0.001);
    }

    /**
     * Test case for division with zero - should throw exception
     */
    @Test(expected = IllegalArgumentException.class)
    public void testDivideByZero() {
        calculator.divide(10, 0);
    }

    /**
     * Test case for multiplication with zero
     */
    @Test
    public void testMultiplyByZero() {
        int result = calculator.multiply(5, 0);
        assertEquals("5 * 0 should equal 0", 0, result);
    }
}
