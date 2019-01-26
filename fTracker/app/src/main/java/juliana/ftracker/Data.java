package juliana.ftracker;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import java.io.Console;

public class Data extends AppCompatActivity {

    //ProgressBar pB1 = (ProgressBar) findViewById(R.id.pBar1);
    int prog = 1;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_data);

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


}
