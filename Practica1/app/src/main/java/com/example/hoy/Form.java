package com.example.hoy;

import android.content.Intent;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;

public class Form extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_form);

        Intent intent = getIntent();
        String message = intent.getStringExtra(RecyclerAdapter.EXTRA_MESSAGE);

        TextView textView = findViewById((R.id.textView2));
        textView.setText(message);
    }
}