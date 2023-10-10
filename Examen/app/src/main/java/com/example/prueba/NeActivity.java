package com.example.prueba;

import android.content.Intent;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import com.squareup.picasso.Picasso;

import java.util.regex.Pattern;

public class NeActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_ne);
        Intent intent = getIntent();
        String message = intent.getStringExtra(ProductListAdapter.EXTRA_MESSAGE);

        TextView textView = findViewById((R.id.textViewDatos));
        textView.setText(message);
    }
}