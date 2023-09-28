package com.example.tab;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import com.google.android.material.bottomsheet.BottomSheetDialogFragment;

import java.util.Random;

public class AddNewTaskListView extends BottomSheetDialogFragment {

    Random random = new Random();

    //    List<String> colorList = Arrays.asList("#775447", "#607d8b", "#03a9f4", "#f44336", "#009688");
    public static final String TAG = "ActionBottomDialog";
    private EditText newTaskText;
    private Button newTaskSaveButton;
    private Button newTaskDeleteButton;

    public static AddNewTaskListView newInstance() {
        return new AddNewTaskListView();
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NORMAL, R.style.DialogStyle);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.listview_new_task, container, false);
        getDialog().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

        return view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        newTaskText = getView().findViewById(R.id.newTaskTextListView);
        newTaskSaveButton = getView().findViewById(R.id.newTaskButtonListView);
        newTaskDeleteButton = getView().findViewById(R.id.deleteTaskButtonListView);

        boolean isUpdate = false;

        final Bundle bundle = getArguments();
        newTaskDeleteButton.setEnabled(false);
        if (bundle != null) {
            newTaskDeleteButton.setEnabled(true);
            newTaskDeleteButton.setTextColor(ContextCompat.getColor(getContext(), R.color.red));
            isUpdate = true;
            String task = bundle.getString("task");
            newTaskText.setText(task);
            assert task != null;
            if (task.length() > 0)
                newTaskSaveButton.setTextColor(ContextCompat.getColor(getContext(), R.color.purple_700));
        }

        newTaskText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.toString().equals("")) {
                    newTaskSaveButton.setEnabled(false);
                    newTaskSaveButton.setTextColor(Color.GRAY);
                } else {
                    newTaskSaveButton.setEnabled(true);
                    newTaskSaveButton.setTextColor(ContextCompat.getColor(getContext(), R.color.purple_700));
                }
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        final boolean finalIsUpdate = isUpdate;
        newTaskSaveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String text = newTaskText.getText().toString();
                if (finalIsUpdate) {
                    DataHandler.updateTask(bundle.getInt("id"), text, "list");
                } else {
                    ToDoModel task = new ToDoModel();
                    task.setColor(String.format("#%06x", random.nextInt(0xffffff + 1)));
                    task.setTask(text);
                    task.setStatus(0);
                    DataHandler.insertTask(task, "list");
                }
                dismiss();
            }
        });

        newTaskDeleteButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder builder = new AlertDialog.Builder(getContext());
                builder.setTitle("Delete Task");
                builder.setMessage("Are you sure you want to delete this Task?");
                builder.setPositiveButton("Confirm",
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                DataHandler.deleteTask(bundle.getInt("id"), "list");
                                dismiss();
                            }
                        });
                builder.setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dismiss();
                    }
                });
                AlertDialog dialog = builder.create();
                dialog.show();
            }
        });
    }

    @Override
    public void onDismiss(@NonNull DialogInterface dialog) {
        Fragment fragment = getParentFragment();
        if (fragment instanceof DialogCloseListener)
            ((DialogCloseListener) fragment).handleDialogClose(dialog);
    }
}

