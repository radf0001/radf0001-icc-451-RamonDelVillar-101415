package com.example.tarea4;

import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.widget.Toast;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.ItemTouchHelper;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.example.tarea4.data.TareaDao;
import com.example.tarea4.data.TareaViewModel;
import com.example.tarea4.databinding.ActivityMainBinding;
import com.example.tarea4.entities.Tarea;

import java.util.Random;

public class MainActivity extends AppCompatActivity {

    private TareaViewModel mTareaViewModel;
    Random random = new Random();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ActivityMainBinding binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        RecyclerView recyclerView = binding.tasksRecyclerView;

        // Get a new or existing ViewModel from the ViewModelProvider.
        mTareaViewModel = new ViewModelProvider(this).get(TareaViewModel.class);

        final TareaListAdapter adapter = new TareaListAdapter(new TareaListAdapter.TareaDiff(), mTareaViewModel, MainActivity.this);
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(getApplicationContext()));

        ItemTouchHelper itemTouchHelper = new
                ItemTouchHelper(new RecyclerItemTouchHelper(adapter));
        itemTouchHelper.attachToRecyclerView(binding.tasksRecyclerView);

        // Add an observer on the LiveData returned by getAlphabetizedWords.
        // The onChanged() method fires when the observed data changes and the activity is
        // in the foreground.
        // Update the cached copy of the words in the adapter.
        mTareaViewModel.getAllTareas().observe(this, adapter::submitList);

        binding.fab.setOnClickListener(view -> {
            Intent intent = new Intent(MainActivity.this, NewTaskActivty.class);
            tareaActivityResultLauncher.launch(intent);
        });
    }
    ActivityResultLauncher<Intent> tareaActivityResultLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                if (result.getResultCode() == Activity.RESULT_OK && result.getData() != null) {
                    Intent data = result.getData();
                    Tarea tarea = new Tarea(false, String.format("#%06x", random.nextInt(0xffffff + 1)), data.getStringExtra(NewTaskActivty.EXTRA_REPLY));
                    mTareaViewModel.insert(tarea);
                } else if (result.getResultCode() == Activity.RESULT_FIRST_USER && result.getData() != null) {
                    Intent data = result.getData();
                    mTareaViewModel.updateTask(data.getStringExtra(NewTaskActivty.EXTRA_REPLY), data.getIntExtra("id", -1));
                } else {
                    Toast.makeText(getApplicationContext(), R.string.empty_not_saved, Toast.LENGTH_LONG).show();
                }
            });
}