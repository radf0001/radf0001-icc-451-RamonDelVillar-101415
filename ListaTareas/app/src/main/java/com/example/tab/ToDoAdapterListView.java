package com.example.tab;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Paint;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;

import java.util.List;

public class ToDoAdapterListView extends ArrayAdapter<ToDoModel>
{
    private Fragmento1 fragment;
    public ToDoAdapterListView(Context context, List<ToDoModel> todoList, Fragmento1 fragment)
    {
        super(context, 0, todoList);
        this.fragment = fragment;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent)
    {
        ToDoModel item = getItem(position);
        if(convertView == null)
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.listview_task_layout, parent, false);

        CheckBox task = convertView.findViewById(R.id.todoCheckBoxListView);
        Button iconImage = convertView.findViewById(R.id.iconImageViewListView);

        iconImage.setBackgroundColor(Color.parseColor(item.getColor()));
        task.setText(item.getTask());
        task.setChecked(toBoolean(item.getStatus()));

        if (item.getStatus() == 1) {
            task.setPaintFlags(task.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
        } else {
            task.setPaintFlags(task.getPaintFlags() & (~ Paint.STRIKE_THRU_TEXT_FLAG));
        }
        task.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    DataHandler.updateStatus(item.getId(), 1, "list");
                    task.setPaintFlags(task.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
                } else {
                    DataHandler.updateStatus(item.getId(), 0, "list");
                    task.setPaintFlags(task.getPaintFlags() & (~ Paint.STRIKE_THRU_TEXT_FLAG));

                }
            }
        });
        iconImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Bundle bundle = new Bundle();
                bundle.putInt("id", item.getId());
                bundle.putString("task", item.getTask());
                AddNewTaskListView fragmento = new AddNewTaskListView();
                fragmento.setArguments(bundle);
                fragmento.show(fragment.getChildFragmentManager(), AddNewTaskListView.TAG);
            }
        });
        return convertView;
    }

    private boolean toBoolean(int n) {
        return n != 0;
    }
}
