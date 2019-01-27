package juliana.ftracker;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        get_json();

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

            //Button bN1 = (Button) findViewById(R.id.bNext);
            TextView tF = (TextView) findViewById(R.id.tFood);
            tF.setText("Bananas: " + Times);
            //Toast.makeText(getApplicationContext(),Times,Toast.LENGTH_LONG).show();


        } catch (IOException e){
            e.printStackTrace();
        } catch(JSONException e){

        }
    }

    //Button bN1 = (Button) findViewById(R.id.bNext);

    public void onClickBtn(View v)
    {
        //Toast.makeText(this, "Clicked on Button", Toast.LENGTH_LONG).show();
        startActivity(new Intent(MainActivity.this, Data.class));
    }





}
