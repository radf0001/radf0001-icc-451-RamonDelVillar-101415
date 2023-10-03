package com.example.tarea4;

import android.content.Intent;
import android.text.TextUtils;
import android.widget.Button;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import com.example.tarea4.databinding.ActivityNewTaskActivtyBinding;

public class NewTaskActivty extends AppCompatActivity {

    public static final String EXTRA_REPLY = "wordlistsql.REPLY";
    private ActivityNewTaskActivtyBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent myIntent = getIntent();

        binding = ActivityNewTaskActivtyBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        if(myIntent.getIntExtra("id", -1) != -1){
            binding.editWord.setText(myIntent.getStringExtra("task"));
        }

        final Button button = binding.buttonSave;
        button.setOnClickListener(view -> {
            Intent replyIntent = new Intent();
            if (TextUtils.isEmpty(binding.editWord.getText())) {
                setResult(RESULT_CANCELED, replyIntent);
            } else {
                if(myIntent.getIntExtra("id", -1) != -1){
                    String task = binding.editWord.getText().toString();
                    replyIntent.putExtra(EXTRA_REPLY, task);
                    replyIntent.putExtra("id", myIntent.getIntExtra("id", -1));
                    setResult(RESULT_FIRST_USER, replyIntent);
                }else{
                    String task = binding.editWord.getText().toString();
                    replyIntent.putExtra(EXTRA_REPLY, task);
                    setResult(RESULT_OK, replyIntent);
                }
            }
            finish();
        });
    }
}