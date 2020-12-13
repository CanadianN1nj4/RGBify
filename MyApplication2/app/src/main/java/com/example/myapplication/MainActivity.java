package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final Button _button = (Button) findViewById(R.id._button);
        _button.setOnClickListener(new View.OnClickListener() {
            public void onClick (View v){
                if(_button.getText() == "Hello"){
                    _button.setText("Tylor");
                } else{
                    _button.setText("Hello");

                }
            }
        });

    }



}
