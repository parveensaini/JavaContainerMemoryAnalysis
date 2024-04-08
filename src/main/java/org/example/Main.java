package org.example;

import org.tensorflow.SavedModelBundle;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Main {
    public static void main(String[] args) throws InterruptedException {
        Set<String> set = new HashSet<>();
        Map<String, String> map = new HashMap<>();
        for(int i=0; i< 100000; ++i) {
            set.add("very long string " + i);
            map.put("very long string" + i, "very long string" + i+1);
        }
        for(int i=0; i< 200; ++i) {
            System.out.println("model number " + i);
            SavedModelBundle model = SavedModelBundle.load("src/main/resources/model/", "serve");
        }

        System.out.println("Hello world!");
        Thread.sleep(10 * 60 * 1000);
    }
}