package NeuralNetwork;

import java.io.*;
import java.util.*;

public class DataFile {
    LineNumberReader reader;
    String line = null;
    Vector<Example> examples = new Vector<Example>();
    double maxes[];
    
    public DataFile(String fileName) {
        InputStream is = DataFile.class.getResourceAsStream(fileName);
        
        //try {
            reader = new LineNumberReader(new InputStreamReader(DataFile.class.getResourceAsStream(fileName)));
        //} catch (FileNotFoundException e) {
            //System.out.println("Couldn't open \"" + fileName + "\"");
            //System.exit(1);
        //}
          
        while (next_line() != null) {
            Example example = new Example();
            StringTokenizer tokens = new StringTokenizer(line, " ");
            int targetValue = new Integer(tokens.nextToken());
            for (int i = 0; i < 3; i++)
                example.targetValues.add(0.1);
            example.targetValues.set(targetValue - 1, 0.9);
            while (tokens.hasMoreTokens()) {
                String token = tokens.nextToken();
                //System.out.println(token);
            
                example.inputs.add(new Double(token));
            }
            examples.add(example);
        }
    }
    
    void compute_maxes() {
        maxes = new double[examples.get(0).inputs.size()];
        for (Example example : examples) {
            for (int i = 0; i < example.inputs.size(); i++)
                if (example.inputs.get(i) > maxes[i])
                    maxes[i] = example.inputs.get(i);
        }
    }
    
    void normalize() {
        compute_maxes();
        for (Example example : examples)
            for (int i = 0; i < example.inputs.size(); i++)
                example.inputs.set(i, example.inputs.get(i)/ maxes[i]);
    }

    Vector<Example> get_examples() { return examples; }
    
    String next_line() {
        try {
            line = reader.readLine();
        } catch (IOException e) {
            System.out.println("Error reading line number " + reader.getLineNumber());
            System.exit(0);
        }
        return line;
    }
}
