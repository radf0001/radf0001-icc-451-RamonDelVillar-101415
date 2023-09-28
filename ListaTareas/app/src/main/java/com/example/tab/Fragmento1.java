package com.example.tab;

import android.content.DialogInterface;
import android.os.Bundle;
import android.widget.ListView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

import java.util.Collections;
import java.util.List;


public class Fragmento1 extends Fragment implements DialogCloseListener{

    private ListView tasksListView;
    private ToDoAdapterListView tasksAdapter;
    private FloatingActionButton fab;
    private static final String TAG = "Fragmento1";

    public Fragmento1() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_fragmento1, container, false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState){
        super.onViewCreated(view, savedInstanceState);

        tasksListView = view.findViewById(R.id.taskListView);
        setAdapter();

        fab = view.findViewById(R.id.fabListView);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AddNewTaskListView.newInstance().show(getChildFragmentManager(), AddNewTaskListView.TAG);
            }
        });
    }

    public void setAdapter(){
        List<ToDoModel> taskList = DataHandler.getAllTasks("list");
        Collections.reverse(taskList);
        tasksAdapter = new ToDoAdapterListView(getContext(), taskList, this);
        tasksListView.setAdapter(tasksAdapter);
    }

    @Override
    public void handleDialogClose(DialogInterface dialog){
        setAdapter();
    }
}