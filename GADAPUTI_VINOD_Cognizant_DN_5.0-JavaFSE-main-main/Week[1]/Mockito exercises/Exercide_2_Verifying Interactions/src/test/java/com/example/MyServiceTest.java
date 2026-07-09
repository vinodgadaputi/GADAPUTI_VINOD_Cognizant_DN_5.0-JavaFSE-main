package com.example;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import org.junit.jupiter.api.Test;

public class MyServiceTest {
    @Test
    public void testVerifyInteractionWithArgument() {
        ExternalApi mockApi = mock(ExternalApi.class);
        MyService service = new MyService(mockApi);

        service.fetchData("hello");

        verify(mockApi).getData("hello");
    }
}
