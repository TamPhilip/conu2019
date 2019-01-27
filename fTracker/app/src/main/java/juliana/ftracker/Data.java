package juliana.ftracker;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.Console;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;

public class Data extends AppCompatActivity {

    //ProgressBar pB1 = (ProgressBar) findViewById(R.id.pBar1);
    int prog = 1;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_data);
        get_json();

        ProgressBar pB1 = (ProgressBar) findViewById(R.id.pBar1);

        pB1.setScaleY(3f);
        // Max Minute
        pB1.setMax(7);
        // Progress Minute
        pB1.setProgress(prog);
    }

    public void onClickAdd(View v)
    {
        ProgressBar pB1 = (ProgressBar) findViewById(R.id.pBar1);
        Toast.makeText(this, "Add", Toast.LENGTH_LONG).show();
        if (prog < 7) {
            prog++;
        }
        pB1.setProgress(prog);
    }

    public void onClickSub(View v)
    {
        ProgressBar pB1 = (ProgressBar) findViewById(R.id.pBar1);
        Toast.makeText(this, "Sub", Toast.LENGTH_LONG).show();
        if (prog > 0) {
            prog--;
        }
        pB1.setProgress(prog);
    }

    ArrayList<String> numberlist = new ArrayList<>();

    public void get_json() {
        String json;
        try {
            InputStream is = getAssets().open("expiryJSON.json");
            int size = is.available();
            byte[] buffer = new byte[size];
            is.read(buffer);
            is.close();

            json = new String(buffer,"UTF-8");
            JSONArray jsonArray = new JSONArray(json);

            for(int i = 0; i<jsonArray.length();i++){
                JSONObject obj = jsonArray.getJSONObject(i);
                if(obj.getString("Food Product").equals("Bananas")){
                    String Time = obj.getString("Refrigerator Storage");
                    numberlist.add(Time);
                }
            }

            String Times = numberlist.toString();
            Times = Times.substring(1,Times.length()-1);

            Toast.makeText(getApplicationContext(),Times,Toast.LENGTH_LONG).show();


        } catch (IOException e){
            e.printStackTrace();
        } catch(JSONException e){

        }
    }


}
